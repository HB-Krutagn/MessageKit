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
        return progressView
    }()

    open var progressPercentage: Float? = nil {
        didSet {
            setProgress(progress: progressPercentage)
        }
    }
    
    open var progressIndicatorMode: MDCActivityIndicatorMode = .determinate {
        didSet {
            messageProgressView.indicatorMode = progressIndicatorMode
        }
    }
    
    open var progressIndicatorRadius: CGFloat = 20 {
        didSet {
            messageProgressView.indicatorRadius = progressIndicatorRadius
        }
    }
    
    open var progressIndicatorStrockWidth: CGFloat = 4.0 {
        didSet {
            messageProgressView.indicatorStrockWidth = progressIndicatorStrockWidth
        }
    }

    open var progressIndicatorColor: UIColor = .white {
        didSet {
            messageProgressView.indicatorColor = progressIndicatorColor
        }
    }

    open var progressIndicatorTrackEnabled: Bool = true {
        didSet {
            messageProgressView.indicatorTrackEnabled = progressIndicatorTrackEnabled
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

        messageProgressView.addConstraints(left: pictureView.leftAnchor, centerY: pictureView.centerYAnchor, leftConstant: -3)
        messageProgressView.constraint(equalTo: CGSize(width: 46, height: 46))
        messageProgressView.layer.cornerRadius = 23

        messageProgressView.activityIndicator.centerInSuperview()
        messageProgressView.activityIndicator.constraint(equalTo: CGSize(width: 40, height: 40))

        messageProgressView.btnRetry.centerInSuperview()
        messageProgressView.btnRetry.constraint(equalTo: CGSize(width: 40, height: 40))
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
        setProgressViewConfig()
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
                let touchLocation = gesture.location(in: messageContainerView)
                guard messageContainerView.frame.contains(touchLocation) else {
                    super.handleTapGesture(gesture)
                    return
                }
                delegate?.didTapDocument(in: self)
            }
        } else {
            let touchLocation = gesture.location(in: messageContainerView)
            guard messageContainerView.frame.contains(touchLocation) else {
                super.handleTapGesture(gesture)
                return
            }
            delegate?.didTapDocument(in: self)
        }
    }

    func setProgressViewConfig() {
        messageProgressView.indicatorMode = progressIndicatorMode
        messageProgressView.indicatorRadius = progressIndicatorRadius
        messageProgressView.indicatorStrockWidth = progressIndicatorStrockWidth
        messageProgressView.indicatorColor = progressIndicatorColor
        messageProgressView.indicatorTrackEnabled = progressIndicatorTrackEnabled
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
            innerView.backgroundColor = UIColor.incomingInner
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
            progressPercentage = item.mediaProgress
        default:
            break
        }
    }
    
    private func setProgress(progress: Float?) {
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
        if currentProgress >= 1.0 || currentProgress <= 0.0 {
            messageProgressView.isHidden = true
        }
    }
}
