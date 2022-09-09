//
//  DocumentMessageCell.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import UIKit
import Foundation
import MessageKit
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
//        nameLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)
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
//        durationLabel.font = UIFont(name: FontName.Regular.rawValue, size:  IS_iPAD ? 17.0: 14.0)
        durationLabel.text = ""
        durationLabel.textColor = .gray
        return durationLabel
    }()

    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        pictureView.constraint(equalTo: CGSize(width: 40, height: 40))
        pictureView.addConstraints(left: innerView.leftAnchor, centerY: innerView.centerYAnchor, leftConstant: 0)

        nameLabel.constraint(equalTo: CGSize(width: 150, height: 50))
        nameLabel.addConstraints(innerView.topAnchor,left: pictureView.rightAnchor,bottom: sizeLabel.topAnchor,right: innerView.rightAnchor,topConstant: 5, leftConstant: 5, rightConstant: 5)
        
        sizeLabel.addConstraints(nameLabel.bottomAnchor,left: pictureView.rightAnchor, bottom: innerView.bottomAnchor,right: innerView.rightAnchor, leftConstant: 5, bottomConstant: 10, rightConstant: 100,heightConstant: 20)
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
        self.messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 5)
        
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
//        delegate?.didTapDocument(in: self)
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
        
//        var status: MessageStatus = .none
        var messageBody = ""
//        guard let objMessage = DatabaseInterface.shared.getMessagefromID(messageID: message.messageId) else {
//            return
//        }
//        messageBody = objMessage.body ?? ""
//        status = ""//CommonUtilities.statusForValue(value: objMessage.status)
        let atribitedDateString = messagesCollectionView.messagesDataSource?.messageBottomLabelAttributedText(for: message, at: indexPath)
//        if let deliveryStatusIcon = (message as? MockMessage)?.getStatusImage() {
//            timeLabel.setImageWith(text: "\(atribitedDateString?.string ?? "") ", rightIcon: deliveryStatusIcon,imageOffsetY: -2.0)
//        } else {
//            timeLabel.text = atribitedDateString?.string ?? ""
//        }
        let isCurrentUser = dataSource.isFromCurrentSender(message: message)
        let containerLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let containerRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        if  isCurrentUser {
//            groupSenderLabel.showOrHide(isHide: true)
            containerLeftConstraint?.constant = 5
            containerRightConstraint?.constant = -12
//            groupSenderLabel.addConstraints(heightConstant: 0)
            innerView.backgroundColor = UIColor.outgoingInner
            innerView.addConstraints(heightConstant: 65)
        } else {
//            if objMessage.groupFlag {
//                switch self.messageContainerView.style {
//                case .bubbleTail:
//                    groupSenderLabel.showOrHide(isHide: false)
//                    groupSenderLabel.text = message.sender.displayName
//                    groupSenderLabel.textColor = message.sender.displayName.getUIcolor()
//                    innerView.addConstraints(heightConstant: 60)
//                 default:
//                    groupSenderLabel.showOrHide(isHide: true)
//                    innerView.addConstraints(heightConstant: 65)
//                }
//            } else {
//                 groupSenderLabel.showOrHide(isHide: true)
                innerView.addConstraints(heightConstant: 65)
//            }
            containerLeftConstraint?.constant = 12
            containerRightConstraint?.constant = -5
            innerView.backgroundColor = UIColor.green//UIColor.replyIncoming
        }
        
        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        nameLabel.textColor = textColor

//        let textColor = displayDelegate.documentTextColor(for: message, at: indexPath, in: messagesCollectionView)
//        self.nameLabel.textColor = textColor
        
//        self.indicatorView.isHidden = true
//        self.indicatorView.stopAnimating()
        
        self.sizeLabel.text = ""
        switch message.kind {
        case .document(let item):
            if let url = item.url {
                let fileName = url.lastPathComponent
                let imageName = QLPreviewHelper.getDocThumbnail(docUrl: url, fileName: fileName)
                self.pictureView.image = imageName
                nameLabel.text = fileName
                 self.sizeLabel.text = url.fileSizeString + "  " + url.pathExtension.uppercased()
            } else {
                nameLabel.text = "unknown"
                self.pictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: "unknown")
            }
//             var isFileExisted = false
//             if let fileURL = FileTransferManager.getfileUrlFromName(fileName: messageBody), FileManager.default.fileExists(atPath: fileURL.path) {
//                 isFileExisted = true
//             } else {}
//            if isCurrentUser && (status == .pending || status == .sendingProgress || status == .failed) {
//                if (status == .pending || status == .sendingProgress) {
//                    self.indicatorView.isHidden = false
//                    self.indicatorView.startAnimating()
//                } else {
//                    self.indicatorView.isHidden = true
//                    self.indicatorView.stopAnimating()
//                    self.errorImageView.isHidden = false
//                }
                
//            } else if !isFileExisted  && (status == .pending || status == .receiving || status == .failed) {
//                if status == .pending || status == .receiving {
//                    self.indicatorView.isHidden = false
//                    self.indicatorView.startAnimating()
//                } else {
//                    self.indicatorView.isHidden = true
//                    self.indicatorView.stopAnimating()
//                    self.errorImageView.isHidden = false
//                }
//            } else {
//                self.indicatorView.isHidden = true
//                self.indicatorView.stopAnimating()
//            }
        default:
            break
        }
    }
}
