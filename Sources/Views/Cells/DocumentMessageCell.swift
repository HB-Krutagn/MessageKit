//
//  DocumentMessageCell.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import UIKit
import Foundation
import MaterialComponents.MaterialActivityIndicator

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class DocumentMessageCell: MessageContentCell {
    
    public lazy var innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    public lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.messageKitImageWith(type: .unknown)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// The time duration lable to display on audio messages.
    public lazy var nameLabel: MessageLabel = {
        let nameLabel = MessageLabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    
    public lazy var sizeLabel: MessageLabel = {
        let durationLabel = MessageLabel(frame: CGRect.zero)
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.text = ""
        durationLabel.textColor = .gray
        return durationLabel
    }()

    open var messageProgressView: HBProgressView = {
        let progressView = HBProgressView()
        progressView.clipsToBounds = true
        progressView.layer.masksToBounds = true
        progressView.setDefaultConfig()
        return progressView
    }()

    open var progressPercentage: CGFloat? = nil {
        didSet {
            setProgress(progress: progressPercentage)
        }
    }
    
    open var progressIndicatorMode: MDCActivityIndicatorMode = .determinate {
        didSet {
            messageProgressView.activityIndicator.indicatorMode = progressIndicatorMode
        }
    }
    
    open var progressIndicatorRadius: CGFloat = 25 {
        didSet {
            messageProgressView.activityIndicator.radius = progressIndicatorRadius
        }
    }
    
    open var progressIndicatorStrockWidth: CGFloat = 5.0 {
        didSet {
            messageProgressView.activityIndicator.strokeWidth = progressIndicatorStrockWidth
        }
    }

    open var progressIndicatorColor: UIColor = .white {
        didSet {
            messageProgressView.activityIndicator.cycleColors = [progressIndicatorColor]
        }
    }

    open var progressIndicatorTrackEnabled: Bool = true {
        didSet {
            messageProgressView.activityIndicator.trackEnabled = progressIndicatorTrackEnabled
        }
    }

    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        pictureView.constraint(equalTo: CGSize(width: 40, height: 40))
        pictureView.addConstraints(left: innerView.leftAnchor, centerY: innerView.centerYAnchor, leftConstant: 5)

        nameLabel.constraint(equalTo: CGSize(width: 150, height: 50))
        nameLabel.addConstraints(innerView.topAnchor,left: pictureView.rightAnchor,bottom: sizeLabel.topAnchor,right: innerView.rightAnchor,topConstant: 8, leftConstant: 5, rightConstant: 5)
        
        sizeLabel.addConstraints(nameLabel.bottomAnchor,left: pictureView.rightAnchor, bottom: innerView.bottomAnchor,right: innerView.rightAnchor, leftConstant: 5, bottomConstant: 8, rightConstant: 100, heightConstant: 20)
        messageProgressView.fillSuperview()
        messageProgressView.activityIndicator.constraint(equalTo: CGSize(width: 40, height: 40))
        messageProgressView.activityIndicator.addConstraints(left: pictureView.leftAnchor, centerY: pictureView.centerYAnchor, leftConstant: 0)
        messageProgressView.btnRetry.constraint(equalTo: CGSize(width: 40, height: 40))
        messageProgressView.btnRetry.addConstraints(left: pictureView.leftAnchor, centerY: pictureView.centerYAnchor, leftConstant: 0)
    }

    open override func setupSubviews() {
        super.setupSubviews()
        innerView.addSubview(pictureView)
        innerView.addSubview(nameLabel)
        innerView.addSubview(sizeLabel)
        
        let mainStackView = UIStackView(arrangedSubviews: [innerView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 2.0
        messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 5)
        messageContainerView.addSubview(messageProgressView)
        messageProgressView.isHidden = true
        setupConstraints()
    }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
      super.apply(layoutAttributes)
      if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
          nameLabel.messageLabelFont = attributes.messageLabelFont
      }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = "unknown"
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        if !messageProgressView.isHidden {
            let touchLocation = gesture.location(in: messageProgressView)
            if messageProgressView.btnCancel.frame.contains(touchLocation) {
                delegateProgress?.didTapCancelProgress(in: self)
            } else if messageProgressView.btnRetry.frame.contains(touchLocation) {
                delegateProgress?.didTapRetryProgress(in: self)
            } else {
                delegate?.didTapDocument(in: self)
            }
        } else {
            delegate?.didTapDocument(in: self)
        }
    }

    // MARK: - Configure Cell

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError("MessageKitError.nilMessagesDataSource")
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessageKitError.nilMessagesDisplayDelegate")
        }
        
        let atribitedDateString = messagesCollectionView.messagesDataSource?.messageBottomLabelAttributedText(for: message, at: indexPath)
        let isCurrentUser = dataSource.isFromCurrentSender(message: message)
        let containerLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let containerRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        let containerTopConstraint = messageContainerView.constraints.filter { $0.identifier == "top" }.first
        let containerBottomConstraint = messageContainerView.constraints.filter { $0.identifier == "bottom" }.first
        if  isCurrentUser {
            containerLeftConstraint?.constant = 6
            containerRightConstraint?.constant = -6
            containerTopConstraint?.constant = 6
            containerBottomConstraint?.constant = -6
            innerView.backgroundColor = UIColor.outgoingInner
            innerView.addConstraints(heightConstant: 65)
        } else {
            innerView.addConstraints(heightConstant: 65)
            containerLeftConstraint?.constant = 6
            containerRightConstraint?.constant = -6
            containerTopConstraint?.constant = 6
            containerBottomConstraint?.constant = -6
            innerView.backgroundColor = UIColor.white
        }
//
//        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
//        nameLabel.textColor = textColor
        nameLabel.textColor = .darkText
        sizeLabel.textColor = .darkGray
        
        self.sizeLabel.text = ""
        switch message.kind {
        case .document(let item):
            if let url = item.url {
                let fileName = url.lastPathComponent
                let imageName = QLPreviewHelper.getDocThumbnail(docUrl: url, fileName: fileName)
                pictureView.image = imageName
                nameLabel.text = fileName
                sizeLabel.text = url.fileSizeString + "  " + url.pathExtension.uppercased()
            } else {
                nameLabel.text = "unknown"
                pictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: "unknown")
            }
        default:
            break
        }
    }
    
    private func setProgress(progress: CGFloat?) {
        guard let currentProgress = progress else {
            messageProgressView.isHidden = true
            return
        }
        messageProgressView.isHidden = false
        messageProgressView.progress = currentProgress
        messageProgressView.onCompletionOfProgress = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.messageProgressView.isHidden = true
        }
    }
}
