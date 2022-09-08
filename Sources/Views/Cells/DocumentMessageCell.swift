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
        imageView.image = UIImage(named: "pdf")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// The time duration lable to display on audio messages.
    public lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
//        nameLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    public lazy var sizeLabel: UILabel = {
        let durationLabel = UILabel(frame: CGRect.zero)
        durationLabel.textAlignment = .left
//        durationLabel.font = UIFont(name: FontName.Regular.rawValue, size:  IS_iPAD ? 17.0: 14.0)
        durationLabel.text = ""
        durationLabel.textColor = .gray
        return durationLabel
    }()
    public lazy var timeLabel: InsetLabel = {
        let label = InsetLabel()
        label.textAlignment = .right
        label.numberOfLines = 0
//        label.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 12.0)!
        label.textColor = .gray
        return label
    }()
//    open var indicatorView: NVActivityIndicatorView = {
//        let indicator = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: 3)
//        return indicator
//    }()
    open lazy var groupSenderLabel: UILabel = {
           let senderLabel = UILabel(frame: CGRect.zero)
//           senderLabel.font = UIFont(name: FontName.Semibold.rawValue, size: IS_iPAD ? 14.0: 12.0)
           senderLabel.textColor = .black
           senderLabel.numberOfLines = 1
           return senderLabel
       }()
    open var errorImageView: UIImageView = {
        let errorImg = UIImageView()
        errorImg.image = UIImage(named: "retry")//"warn_icon"
        errorImg.contentMode = .scaleToFill
        return errorImg
    }()
    // MARK: - Methods

    /// Responsible for setting up the constraints of the cell's subviews.
    open func setupConstraints() {
        pictureView.constraint(equalTo: CGSize(width: 40, height: 40))
        pictureView.addConstraints(left: innerView.leftAnchor, centerY: innerView.centerYAnchor, leftConstant: 0)
        
//        indicatorView.centerInSuperview()
//        indicatorView.constraint(equalTo: CGSize(width: 40, height: 40))
        
//        nameLabel.constraint(equalTo: CGSize(width: 150, height: 50))
        nameLabel.addConstraints(innerView.topAnchor,left: pictureView.rightAnchor,bottom: sizeLabel.topAnchor,right: innerView.rightAnchor,topConstant: 0, leftConstant: 5, rightConstant: 5)
        
        sizeLabel.addConstraints(nameLabel.bottomAnchor,left: pictureView.rightAnchor, bottom: innerView.bottomAnchor,right: innerView.rightAnchor, leftConstant: 5, bottomConstant: 10, rightConstant: 100,heightConstant: 20)
        
        timeLabel.addConstraints(right: innerView.rightAnchor,centerY:sizeLabel.centerYAnchor,rightConstant: 5, widthConstant: 100, heightConstant: 20)
        
        errorImageView.centerInSuperview()
        errorImageView.constraint(equalTo: CGSize(width: 40, height: 40))
        errorImageView.layer.cornerRadius = 20
//        errorImageView.setRoundCorner(radius: 20)
        errorImageView.isHidden = true
    }

    open override func setupSubviews() {
        super.setupSubviews()
        innerView.addSubview(pictureView)
        innerView.addSubview(nameLabel)
//        pictureView.addSubview(indicatorView)
        pictureView.addSubview(errorImageView)
        innerView.addSubview(sizeLabel)
        innerView.addSubview(timeLabel)
        
        
        let mainStackView = UIStackView(arrangedSubviews: [groupSenderLabel,innerView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 2.0
        self.messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 12)
        
        setupConstraints()
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
            timeLabel.text = atribitedDateString?.string ?? ""
//        }
        let isCurrentUser = dataSource.isFromCurrentSender(message: message)
        let containerLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let containerRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        if  isCurrentUser {
//            groupSenderLabel.showOrHide(isHide: true)
            containerLeftConstraint?.constant = 5
            containerRightConstraint?.constant = -12
//            groupSenderLabel.addConstraints(heightConstant: 0)
            innerView.backgroundColor = UIColor.red//UIColor.replyOutgoing
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
        self.errorImageView.isHidden = true
        self.sizeLabel.text = ""
        switch message.kind {
        case .document(let item):
            if let url = item.url {
                let fileName = url.lastPathComponent
//                let imageName = QLPreviewHelper.getDocThumbnail(docUrl: url, fileName: fileName)
//                self.pictureView.image = imageName
                nameLabel.text = fileName
                self.sizeLabel.text = "40 kb"
//                 self.sizeLabel.text = url.fileSizeString + "  " + url.pathExtension.uppercased()
            } else {
                nameLabel.text = "unknown"
//                self.pictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: "unknown")
            }
            var isFileExisted = false
//             if let fileURL = FileTransferManager.getfileUrlFromName(fileName: messageBody), FileManager.default.fileExists(atPath: fileURL.path) {
//                 isFileExisted = true
//             } else {}
            self.errorImageView.isHidden = true
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
