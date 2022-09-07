//
//  ReplyMessageCell.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class ReplyMessageCell: MessageContentCell {
    
    public lazy var innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
    }()
    
    public lazy var leftVerticalView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public lazy var innerItemView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    open lazy var senderLabel: UILabel = {
        let senderLabel = UILabel(frame: CGRect.zero)
        senderLabel.font = UIFont(name: FontName.Semibold.rawValue, size: IS_iPAD ? 14.0: 12.0)
        senderLabel.textColor = .black
        senderLabel.numberOfLines = 1
        return senderLabel
    }()
    
    public lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "text")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    open lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 14.0: 12.0)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 2
        return messageLabel
    }()
    
    public lazy var emptyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "lastMesgPhoto"), for: .normal)
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 14.0: 12.0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    public lazy var mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: kPlacehoderMedia)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //Reply message variables
    
    public lazy var replyInnerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    open lazy var replyMessageLabel: UILabel = {
        let captionLabel = UILabel(frame: CGRect.zero)
        captionLabel.lineBreakMode = .byWordWrapping
        captionLabel.backgroundColor = .clear
        captionLabel.textAlignment = .left
        captionLabel.textColor = .black
        captionLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)
        captionLabel.text = ""
        captionLabel.numberOfLines = 0
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
    }()
    
    //Media
    
    open var replyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// The play button view to display on video messages.
    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()
    
    
    open var indicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: 3)
        return indicator
    }()
    
    open var errorImageView: UIImageView = {
        let errorImg = UIImageView()
        errorImg.image = UIImage(named: "icon_video_unavail")//"warn_icon"
        errorImg.contentMode = .scaleAspectFit
        return errorImg
    }()
    
    //Document
    
    public lazy var replyDocumentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var replyDocumentPictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pdf")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// The time duration lable to display on audio messages.
    public lazy var replyDocumentNameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byTruncatingMiddle
        return nameLabel
    }()
    public lazy var replyDocumentSizeLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 13.0)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColor.gray
        return nameLabel
    }()
    public lazy var replyDocumentTimeLabel: InsetLabel = {
        let label = InsetLabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 12.0)!
        label.textColor = .gray
        return label
    }()
    //Audio
    
    public lazy var replyAudioView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var replyAudioPlayButton: UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.imageEdgeInsets = .init(top: 7, left: 9, bottom: 7, right: 7)
        playButton.setImageWith(name: "icon_play", color: .white, state: .normal)
        playButton.setImageWith(name: "icon_pause", color: .white, state: .selected)
        playButton.backgroundColor = .themeColor
        return playButton
    }()

    /// The time duration lable to display on audio messages.
    public lazy var replyAudioDurationLabel: UILabel = {
        let durationLabel = UILabel(frame: CGRect.zero)
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 13.0)
        durationLabel.text = "0:00"
        return durationLabel
    }()
    public lazy var replyAudioTimeLabel: InsetLabel = {
        let label = InsetLabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 12.0)!
        label.textColor = .gray
        return label
    }()

    public lazy var replyAudioProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        return progressView
    }()
    public lazy var timeLabel: InsetLabel = {
        let label = InsetLabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 15.0: 12.0)!
        label.textColor = .gray
        return label
    }()
    
    var mainStackView = UIStackView()
    var replyDocumentStackView = UIStackView() {
        didSet {
            replyDocumentStackView.setCustomRoundedCornerRadius(value: 5)
        }
    }
    var replyAudioStackView = UIStackView(){
        didSet {
            replyAudioStackView.setCustomRoundedCornerRadius(value: 5)
        }
    }
    open lazy var groupSenderLabel: UILabel = {
           let senderLabel = UILabel(frame: CGRect.zero)
           senderLabel.font = UIFont(name: FontName.Semibold.rawValue, size: IS_iPAD ? 14.0: 12.0)
           senderLabel.textColor = .black
           senderLabel.numberOfLines = 1
           return senderLabel
       }()
    // MARK: - Methods
    open override func setupSubviews() {
        super.setupSubviews()
        replyImageView.addSubview(playButtonView)
        replyImageView.addSubview(indicatorView)
        replyImageView.addSubview(errorImageView)
        
        replyAudioView.addSubview(replyAudioPlayButton)
        replyAudioView.addSubview(replyAudioProgressView)
        replyAudioView.addSubview(replyAudioDurationLabel)
        replyAudioView.addSubview(replyAudioTimeLabel)
        
        
        
        let replyDocumentInnerView = UIView()
        replyDocumentInnerView.addSubview(replyDocumentNameLabel)
        replyDocumentInnerView.addSubview(replyDocumentSizeLabel)
        replyDocumentInnerView.addSubview(replyDocumentTimeLabel)
        
        
        replyDocumentStackView = UIStackView(arrangedSubviews: [replyDocumentPictureView,replyDocumentInnerView])
        replyDocumentStackView.axis = .horizontal
        replyDocumentStackView.distribution = .fill
        replyDocumentStackView.spacing = 2.0
        replyDocumentStackView.clipsToBounds = true
        
        let replyContentStackView = UIStackView(arrangedSubviews: [replyImageView, replyMessageLabel,replyDocumentStackView,replyAudioView])
        replyContentStackView.axis = .vertical
        replyContentStackView.distribution = .fill
        

        mainStackView = UIStackView(arrangedSubviews: [groupSenderLabel,innerView, replyContentStackView, timeLabel])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 2.0
        self.messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 12)
        innerView.addConstraints(heightConstant: 60)
        timeLabel.addConstraints(heightConstant: 20)
        
        
        
        let innerMessageStackView = UIStackView(arrangedSubviews: [iconView,messageLabel])
        innerMessageStackView.axis = .horizontal
        innerMessageStackView.distribution = .fill
        innerMessageStackView.spacing = 2.0
        innerMessageStackView.clipsToBounds = true

        let tempView = UIView()
        let innerSenderAndMessageStackView = UIStackView(arrangedSubviews: [senderLabel,innerMessageStackView,tempView])
        innerSenderAndMessageStackView.axis = .vertical
        innerSenderAndMessageStackView.distribution = .fill
        innerSenderAndMessageStackView.spacing = 1.0
        innerSenderAndMessageStackView.clipsToBounds = true


        let innerStackView = UIStackView(arrangedSubviews: [leftVerticalView,innerSenderAndMessageStackView,mediaImageView])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .fill
        innerStackView.alignment = .fill
        innerStackView.spacing = 5.0
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.clipsToBounds = true
        innerView.addSubview(innerStackView)
        innerView.clipsToBounds = true
        innerStackView.addConstraints(innerView.topAnchor,left: innerView.leftAnchor,bottom: innerView.bottomAnchor,right: innerView.rightAnchor,rightConstant: 5)
        leftVerticalView.addConstraints(widthConstant: 5)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.addConstraints(widthConstant:30)
        mediaImageView.addConstraints(innerStackView.topAnchor,bottom: innerStackView.bottomAnchor,right: innerStackView.rightAnchor,topConstant: 5,bottomConstant: 5,rightConstant: 5,widthConstant: 30)
        
        senderLabel.addConstraints(innerSenderAndMessageStackView.topAnchor,topConstant: 5)
        innerSenderAndMessageStackView.addConstraints(innerStackView.topAnchor, bottom: innerStackView.bottomAnchor)
        tempView.addConstraints(heightConstant: 8)
        
        //Current pictiure Message
        replyImageView.addConstraints(replyContentStackView.topAnchor,topConstant: 5,heightConstant: 260)
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 35, height: 35))
        
        indicatorView.centerInSuperview()
        indicatorView.constraint(equalTo: CGSize(width: 40, height: 40))
        
        errorImageView.centerInSuperview()
        errorImageView.constraint(equalTo: CGSize(width: 80, height: 80))
        errorImageView.isHidden = true
       
        //Document
        replyDocumentPictureView.addConstraints(left:replyDocumentStackView.leftAnchor,leftConstant: 5)
        replyDocumentPictureView.addConstraints(widthConstant:30)
        replyDocumentSizeLabel.addConstraints(left: replyDocumentInnerView.leftAnchor, bottom: replyDocumentInnerView.bottomAnchor,right: replyDocumentInnerView.rightAnchor, leftConstant: 5,bottomConstant: 5, rightConstant: 100,heightConstant: 20)
        replyDocumentTimeLabel.addConstraints(right: replyDocumentInnerView.rightAnchor,centerY:replyDocumentSizeLabel.centerYAnchor,rightConstant: 5, widthConstant: 100, heightConstant: 20)
        replyDocumentNameLabel.addConstraints(replyDocumentInnerView.topAnchor,left: replyDocumentInnerView.leftAnchor,bottom: replyDocumentSizeLabel.topAnchor,right: replyDocumentInnerView.rightAnchor,topConstant: 5, leftConstant: 5,rightConstant: 5)
        
        //Audio
        replyAudioView.addConstraints(heightConstant: 60)
        replyAudioPlayButton.constraint(equalTo: CGSize(width: 35, height: 35))
        replyAudioPlayButton.addConstraints(left: replyAudioView.leftAnchor, centerY: replyAudioView.centerYAnchor, leftConstant: 5)
        replyAudioProgressView.addConstraints(left: replyAudioPlayButton.rightAnchor,right: replyAudioView.rightAnchor, centerY: replyAudioView.centerYAnchor, leftConstant: 5, rightConstant: 5,centerYConstant: -10, heightConstant: 5)
        replyAudioPlayButton.setCustomRoundedCornerRadius(value: 17.5)
        replyAudioDurationLabel.addConstraints(replyAudioProgressView.bottomAnchor,left: replyAudioProgressView.leftAnchor,topConstant: 10,widthConstant: 120)
        replyAudioTimeLabel.addConstraints(right: replyAudioView.rightAnchor,centerY:replyAudioDurationLabel.centerYAnchor,rightConstant: 5, widthConstant: 100, heightConstant: 20)
        
        groupSenderLabel.addConstraints(mainStackView.topAnchor,topConstant: -5)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = ""
        replyMessageLabel.text = ""
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        // compute play button touch area, currently play button size is (25, 25) which is hardly touchable
        // add 10 px around current button frame and test the touch against this new frame
        let playButtonTouchArea = CGRect(replyAudioPlayButton.frame.origin.x - 10.0, replyAudioPlayButton.frame.origin.y - 10, replyAudioPlayButton.frame.size.width + 20, replyAudioPlayButton.frame.size.height + 20)
        let translateTouchLocation = convert(touchLocation, to: replyAudioView)
        let innerViewTouchLocation = convert(touchLocation, to: innerView)
        if playButtonTouchArea.contains(translateTouchLocation) {
            delegate?.didTapAudioPlayButton(in: self)
        } else if innerView.frame.contains(innerViewTouchLocation) { //TOP REPLY
            super.handleTapGesture(gesture)
        }  else {
            delegate?.didTapOnReplyBottomMessage(in: self)
        }
    }

    // MARK: - Configure Cell

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        var senderName: String = ""
        var status: MessageStatus = .none
        var messageBody: String = ""
        guard let objMessage = DatabaseInterface.shared.getMessagefromID(messageID: message.messageId), let oldMessage = DatabaseInterface.shared.getMessagefromID(messageID: objMessage.replyID ?? "")  else {
            return
        }
        senderName = (oldMessage.sectionTitle ?? "")
        messageBody = objMessage.body ?? ""
        status = CommonUtilities.statusForValue(value: objMessage.status)
        self.senderLabel.text = senderName
        let isCurrentUser = dataSource.isFromCurrentSender(message: message)
        let containerLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let containerRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        if isCurrentUser {
            groupSenderLabel.showOrHide(isHide: true)
            containerLeftConstraint?.constant = 5
            containerRightConstraint?.constant = -12
//            groupSenderLabel.addConstraints(heightConstant: 0)
            innerView.backgroundColor = UIColor.replyOutgoing
            replyDocumentStackView.backgroundColor = UIColor.replyOutgoing
            replyAudioView.backgroundColor = UIColor.replyOutgoing
            leftVerticalView.backgroundColor = senderName.getUIcolor()
            senderLabel.textColor = senderName.getUIcolor()
        } else {
            if objMessage.groupFlag {
                switch self.messageContainerView.style {
                case .bubbleTail:
                    groupSenderLabel.showOrHide(isHide: false)
                    groupSenderLabel.text = message.sender.displayName
                    groupSenderLabel.textColor = groupSenderLabel.text?.getUIcolor() ?? .black
                 default:
                    groupSenderLabel.showOrHide(isHide: true)
                }
               
            } else {
                groupSenderLabel.showOrHide(isHide: true)
            }
            containerLeftConstraint?.constant = 12
            containerRightConstraint?.constant = -5
            innerView.backgroundColor = UIColor.replyIncoming
            replyDocumentStackView.backgroundColor = UIColor.replyIncoming
            replyAudioView.backgroundColor = UIColor.replyIncoming
            leftVerticalView.backgroundColor = senderName.getUIcolor()
            senderLabel.textColor = senderName.getUIcolor()
        }
        self.layoutIfNeeded()
        let atribitedDateString = messagesCollectionView.messagesDataSource?.messageBottomLabelAttributedText(for: message, at: indexPath)
        if let deliveryStatusIcon = (message as? MockMessage)?.getStatusImage() {
            timeLabel.setImageWith(text: "\(atribitedDateString?.string ?? "") ", rightIcon: deliveryStatusIcon,imageOffsetY: -2.0)
            replyDocumentTimeLabel.setImageWith(text: "\(atribitedDateString?.string ?? "") ", rightIcon: deliveryStatusIcon,imageOffsetY: -2.0)
            replyAudioTimeLabel.setImageWith(text: "\(atribitedDateString?.string ?? "") ", rightIcon: deliveryStatusIcon,imageOffsetY: -2.0)
        } else {
            timeLabel.text = atribitedDateString?.string ?? ""
            replyDocumentTimeLabel.text = atribitedDateString?.string ?? ""
            replyAudioTimeLabel.text = atribitedDateString?.string ?? ""
        }
        //OLD MESSAGE DETAILS
        self.mediaImageView.showOrHide(isHide: true)
        
        switch message.kind {
        case .reply(let item):
            switch item.replyKind {
            case .text(let text):
                self.iconView.showOrHide(isHide: true)
                self.messageLabel.text = text//oldBodyText
            case .photo(let rItem):
                self.mediaImageView.showOrHide(isHide: false)
                self.iconView.showOrHide(isHide: false)
                self.iconView.image = UIImage(named: "lastMesgPhoto")
                self.messageLabel.text = ((rItem.text ?? "").isEmpty ? "Photo": rItem.text ?? "Photo")
                self.mediaImageView.image = rItem.image
            case .video(let rItem):
                self.mediaImageView.showOrHide(isHide: false)
                self.iconView.showOrHide(isHide: false)
                self.iconView.image = UIImage(named: "lastMesgVideo")
                self.messageLabel.text = ((rItem.text ?? "").isEmpty ? "Video": rItem.text ?? "Video")
                self.mediaImageView.image = rItem.image
            case .audio(let rItem):
                self.iconView.showOrHide(isHide: false)
                self.iconView.image = UIImage(named: "icon_mic")
                self.messageLabel.text = "Audio"
                let audioAsset = AVURLAsset.init(url: rItem.url, options: nil)
                audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
                    var error: NSError? = nil
                    let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                    switch status {
                    case .loaded: // Sucessfully loaded. Continue processing.
                        let duration = audioAsset.duration
                        let durationInSeconds = CMTimeGetSeconds(duration)
                        print(Int(durationInSeconds))
                        var returnValue = "00:00"
                        if durationInSeconds < 60 {
                            returnValue = String(format: "00:%.02d", Int(durationInSeconds.rounded(.up)))
                        } else if durationInSeconds < 3600 {
                            returnValue = String(format: "%.02d:%.02d", Int(durationInSeconds/60), Int(durationInSeconds) % 60)
                        } else {
                            let hours = Int(durationInSeconds/3600)
                            let remainingMinutesInSeconds = Int(durationInSeconds) - hours*3600
                            returnValue = String(format: "%.02d:%.02d:%.02d", hours, Int(remainingMinutesInSeconds/60), Int(remainingMinutesInSeconds) % 60)
                        }
                        DispatchQueue.main.async {
                            self.messageLabel.text = "Audio (\(returnValue))"
                        }
                        break
                    case .failed: break // Handle error
                    case .cancelled: break // Terminate processing
                    default: break // Handle all other cases
                    }
                }
            case .document(let rItem):
                self.iconView.showOrHide(isHide: false)
                self.iconView.image = QLPreviewHelper.getDocThumbnail(docUrl: rItem.url, fileName: rItem.url?.lastPathComponent ?? ".txt")
                self.messageLabel.text = ((rItem.url?.lastPathComponent ?? "").isEmpty ? "Preview": "\(rItem.url?.lastPathComponent ?? "Preview")")
            default:
                break
            }
            //CURRENT MESSAGE DETAILS
            replyImageView.showOrHide(isHide: true)
            replyMessageLabel.showOrHide(isHide: true)
            replyDocumentStackView.showOrHide(isHide: true)
            replyAudioView.showOrHide(isHide: true)
            timeLabel.showOrHide(isHide: false)
            
            playButtonView.isHidden = true
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            errorImageView.isHidden = true
            replyDocumentView.isHidden = true
            
            let replyText = item.text ?? ""
            if item.itemType == attachmentType.text.rawValue {
                replyMessageLabel.showOrHide(isHide: replyText.isEmpty)
                replyMessageLabel.text = replyText
            } else if item.itemType == attachmentType.image.rawValue || item.itemType == attachmentType.video.rawValue {
                let isImage = (item.itemType == attachmentType.image.rawValue)
                replyImageView.showOrHide(isHide: false)
                playButtonView.isHidden = isImage
                if replyText.isEmpty {
                    replyMessageLabel.showOrHide(isHide: true)
                } else {
                    replyMessageLabel.showOrHide(isHide: false)
                }
                replyMessageLabel.text = replyText
                if item.itemType == attachmentType.image.rawValue {
                    replyImageView.sd_setImage(with: item.url, placeholderImage: item.image ?? item.placeholderImage, options: .refreshCached, completed: nil)
                } else {
                    if !messageBody.isEmpty, let url = FileTransferManager.getfileUrlFromName(fileName: messageBody), let objImage = FileManager().getThumbnailFromVideo(url) {
                        replyImageView.image = objImage
                    } else {
                        replyImageView.image = item.image ?? item.placeholderImage
                    }
                    var isFileExisted = false
                    if let fileURL = FileTransferManager.getfileUrlFromName(fileName: messageBody), FileManager.default.fileExists(atPath: fileURL.path), AVAsset(url: fileURL).isPlayable == true {
                        isFileExisted = true
                    } else {
                        //print(.DEBUG,"Not found")
                    }
                    
                    if isCurrentUser && (status == .pending || status == .sendingProgress || status == .failed) {
                        self.indicatorView.isHidden = false
                        self.indicatorView.startAnimating()
                    } else if !isFileExisted  && (status == .pending || status == .receiving || status == .failed) {
                        if status == .pending || status == .receiving {
                            self.indicatorView.isHidden = false
                            self.indicatorView.startAnimating()
                        } else {
                            self.errorImageView.isHidden = false
                        }
                    } else {
                        self.indicatorView.isHidden = true
                        self.indicatorView.stopAnimating()
                    }
                }
            } else if item.itemType == attachmentType.doc.rawValue {
                replyDocumentStackView.showOrHide(isHide: false)
                timeLabel.showOrHide(isHide: true)
                if let url = item.url {
                    self.replyDocumentPictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: url.lastPathComponent)
                    self.replyDocumentNameLabel.text = url.lastPathComponent
                    self.replyDocumentSizeLabel.text = url.fileSizeString + "  " + url.pathExtension.uppercased()
                } else {
                    self.replyDocumentNameLabel.text = "unknown"
                    self.replyDocumentPictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: "txt")
                    self.replyDocumentSizeLabel.text = "0.0 B   Unknown"
                }
            } else if item.itemType == attachmentType.audio.rawValue {
                 self.replyAudioView.showOrHide(isHide: false)
                timeLabel.showOrHide(isHide: true)
                let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
                replyAudioProgressView.tintColor = tintColor
                replyAudioDurationLabel.textColor = tintColor
                replyAudioDurationLabel.text = displayDelegate.replyAudioProgressTextFormat(0, for: self, in: messagesCollectionView)
                displayDelegate.configureReplyAudioCell(self, message: message)
                
                let audioAsset = AVURLAsset.init(url: item.url!, options: nil)
                audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
                    var error: NSError? = nil
                    let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                    switch status {
                    case .loaded: // Sucessfully loaded. Continue processing.
                        let duration = audioAsset.duration
                        let durationInSeconds = CMTimeGetSeconds(duration)
                        print(Int(durationInSeconds))
                        var returnValue = "0:00"
                        if durationInSeconds < 60 {
                            returnValue = String(format: "0:%.02d", Int(durationInSeconds.rounded(.up)))
                        } else if durationInSeconds < 3600 {
                            returnValue = String(format: "%.02d:%.02d", Int(durationInSeconds/60), Int(durationInSeconds) % 60)
                        } else {
                            let hours = Int(durationInSeconds/3600)
                            let remainingMinutesInSeconds = Int(durationInSeconds) - hours*3600
                            returnValue = String(format: "%.02d:%.02d:%.02d", hours, Int(remainingMinutesInSeconds/60), Int(remainingMinutesInSeconds) % 60)
                        }
                        DispatchQueue.main.async {
                            self.replyAudioDurationLabel.text = returnValue
                        }
                        break
                    case .failed: break // Handle error
                    case .cancelled: break // Terminate processing
                    default: break // Handle all other cases
                    }
                }
            } else {}
        default:
            break
        }
        self.layoutIfNeeded()
    }
}
