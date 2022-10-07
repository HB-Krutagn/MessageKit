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
import MessageKit
import AVKit
import MaterialComponents.MaterialActivityIndicator
/// A subclass of `MessageContentCell` used to display video and audio messages.
open class ReplyMessageCell: MessageContentCell {
    
    public lazy var innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
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
        senderLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
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
        messageLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2
        return messageLabel
    }()
    
    public lazy var emptyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "lastMesgPhoto"), for: .normal)
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
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
        view.layer.cornerRadius = 10.0
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
        captionLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        captionLabel.text = ""
        captionLabel.numberOfLines = 0
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
    }()
    
    //Media
    
    open var replyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// The play button view to display on video messages.
    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()
    
    open var indicatorView: HBProgressView = {
        let progressView = HBProgressView()
        progressView.clipsToBounds = true
        progressView.layer.masksToBounds = true
        return progressView
    }()
    
    open var errorImageView: UIImageView = {
        let errorImg = UIImageView()
        errorImg.image = UIImage(named: "icon_video_unavail")//"warn_icon"
        errorImg.contentMode = .scaleAspectFit
        return errorImg
    }()
    
    open var progressPercentage: Float? = nil {
        didSet {
            setProgress(progress: progressPercentage)
        }
    }
    
    open var progressIndicatorMode: MDCActivityIndicatorMode = .determinate {
        didSet {
            indicatorView.indicatorMode = progressIndicatorMode
        }
    }
    
    open var progressIndicatorRadius: CGFloat = 25 {
        didSet {
            indicatorView.indicatorRadius = progressIndicatorRadius
        }
    }
    
    open var progressIndicatorStrockWidth: CGFloat = 5.0 {
        didSet {
            indicatorView.indicatorStrockWidth = progressIndicatorStrockWidth
        }
    }

    open var progressIndicatorColor: UIColor = .white {
        didSet {
            indicatorView.indicatorColor = progressIndicatorColor
        }
    }

    open var progressIndicatorTrackEnabled: Bool = true {
        didSet {
            indicatorView.indicatorTrackEnabled = progressIndicatorTrackEnabled
        }
    }

    //Document
    
    public lazy var replyDocumentInnerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
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
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byTruncatingMiddle
        return nameLabel
    }()
    public lazy var replyDocumentSizeLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColor.gray
        return nameLabel
    }()

    //Audio
    
    public lazy var replyAudioView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var replyAudioPlayButton: UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.imageEdgeInsets = .init(top: 7, left: 9, bottom: 7, right: 7)
        playButton.setImageWith(name: "audio_play", color: .white, state: .normal)
        playButton.setImageWith(name: "audio_pause", color: .white, state: .selected)
        playButton.backgroundColor = .themeColor
        return playButton
    }()

    /// The time duration lable to display on audio messages.
    public lazy var replyAudioDurationLabel: UILabel = {
        let durationLabel = UILabel(frame: CGRect.zero)
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.text = "00:00"
        return durationLabel
    }()

    public lazy var replyAudioProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        progressView.tintColor = UIColor.themeColor
        return progressView
    }()
    
    var mainStackView = UIStackView()
    var replyDocumentStackView = UIStackView() {
        didSet {
            replyDocumentStackView.setRoundCorner(radius: 10)
        }
    }
    var replyAudioStackView = UIStackView() {
        didSet {
            replyAudioStackView.setRoundCorner(radius: 5)
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
        
//        let replyDocumentInnerView = UIView()
        replyDocumentInnerView.addSubview(replyDocumentNameLabel)
        replyDocumentInnerView.addSubview(replyDocumentSizeLabel)
        
        replyDocumentStackView = UIStackView(arrangedSubviews: [replyDocumentPictureView,replyDocumentInnerView])
        replyDocumentStackView.axis = .horizontal
        replyDocumentStackView.distribution = .fill
        replyDocumentStackView.spacing = 2.0
        replyDocumentStackView.clipsToBounds = true
        
        let replyContentStackView = UIStackView(arrangedSubviews: [replyImageView, replyMessageLabel,replyDocumentStackView,replyAudioView])
        replyContentStackView.axis = .vertical
        replyContentStackView.distribution = .fill

        mainStackView = UIStackView(arrangedSubviews: [groupSenderLabel,innerView, replyContentStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 2.0
        self.messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 12)
        innerView.addConstraints(heightConstant: 60)
        
        let innerMessageStackView = UIStackView(arrangedSubviews: [/*iconView,*/messageLabel])
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
        
        //Current picture Message
        replyImageView.addConstraints(replyContentStackView.topAnchor,topConstant: 5,heightConstant: 260)
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 35, height: 35))
                
        errorImageView.centerInSuperview()
        errorImageView.constraint(equalTo: CGSize(width: 80, height: 80))
        errorImageView.isHidden = true
       
        //Document
        replyDocumentInnerView.addConstraints(heightConstant: 60)
        replyDocumentPictureView.addConstraints(left:replyDocumentStackView.leftAnchor,leftConstant: 5)
        replyDocumentPictureView.addConstraints(widthConstant:30)
        replyDocumentSizeLabel.addConstraints(left: replyDocumentInnerView.leftAnchor, bottom: replyDocumentInnerView.bottomAnchor,right: replyDocumentInnerView.rightAnchor, leftConstant: 5,bottomConstant: 5, rightConstant: 100,heightConstant: 20)
        replyDocumentNameLabel.addConstraints(replyDocumentInnerView.topAnchor,left: replyDocumentInnerView.leftAnchor,bottom: replyDocumentSizeLabel.topAnchor,right: replyDocumentInnerView.rightAnchor,topConstant: 5, leftConstant: 5,rightConstant: 5)
        
        //Audio
        replyAudioView.addConstraints(heightConstant: 60)
        replyAudioPlayButton.constraint(equalTo: CGSize(width: 35, height: 35))
        replyAudioPlayButton.addConstraints(left: replyAudioView.leftAnchor, centerY: replyAudioView.centerYAnchor, leftConstant: 5)
        replyAudioPlayButton.setRoundCorner(radius: 17.5)
        
        replyAudioDurationLabel.addConstraints(
          right: replyAudioView.rightAnchor,
          centerY: replyAudioView.centerYAnchor,
          rightConstant: 8)
        
        replyAudioProgressView.addConstraints(
          left: replyAudioPlayButton.rightAnchor,
          right: replyAudioDurationLabel.leftAnchor,
          centerY: replyAudioView.centerYAnchor,
          leftConstant: 5,
          rightConstant: 5)
        
        groupSenderLabel.addConstraints(mainStackView.topAnchor,topConstant: -5)
        
        indicatorView.centerInSuperview()
        indicatorView.constraint(equalTo: CGSize(width: 56, height: 56))
        indicatorView.layer.cornerRadius = 28

        indicatorView.btnRetry.centerInSuperview()
        indicatorView.btnRetry.constraint(equalTo: CGSize(width: 50, height: 50))
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
        let playButtonTouchArea = CGRect(x: replyAudioPlayButton.frame.origin.x - 10.0, y: replyAudioPlayButton.frame.origin.y - 10, width: replyAudioPlayButton.frame.size.width + 20, height: replyAudioPlayButton.frame.size.height + 20)
        let translateTouchLocation = convert(touchLocation, to: replyAudioView)
        let innerViewTouchLocation = convert(touchLocation, to: innerView)
        
        if !indicatorView.isHidden {
            let touchLocation = gesture.location(in: messageContainerView)
            if indicatorView.btnCancel.frame.contains(touchLocation) {
                delegateProgress?.didTapCancelProgress(in: self)
            } else if indicatorView.btnRetry.frame.contains(touchLocation) {
                delegateProgress?.didTapRetryProgress(in: self)
            } else {
                if playButtonTouchArea.contains(translateTouchLocation) {
                    delegate?.didTapReplyAudioPlayButton(in: self)
                } else if innerView.frame.contains(innerViewTouchLocation) { //TOP REPLY
                    super.handleTapGesture(gesture)
                } else if replyImageView.frame.contains(touchLocation) {
                    delegate?.didTapReplyBottomMessage(in: self)
                } else {
                    super.handleTapGesture(gesture)
                }
            }
        } else {
            let touchLocation = gesture.location(in: messageContainerView)
            if playButtonTouchArea.contains(translateTouchLocation) {
                delegate?.didTapReplyAudioPlayButton(in: self)
            } else if innerView.frame.contains(innerViewTouchLocation) { //TOP REPLY
                super.handleTapGesture(gesture)
            } else if replyImageView.frame.contains(touchLocation) {
                delegate?.didTapReplyBottomMessage(in: self)
            } else {
                super.handleTapGesture(gesture)
            }
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
        var senderName: String = ""
        var messageBody: String = ""
        guard let objMessage = message as? MessageMO else {
            return
        }
        let name = objMessage.displayName == " " ? "You" : objMessage.displayName
        senderName = name
        messageBody = objMessage.text ?? ""
        
        self.senderLabel.text = senderName
//        self.messageLabel.text = "ABCCC"
        let isCurrentUser = dataSource.isFromCurrentSender(message: message)
        let containerLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let containerRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        if isCurrentUser {
            groupSenderLabel.showOrHide(isHide: true)
            containerLeftConstraint?.constant = 5
            containerRightConstraint?.constant = -5
            innerView.backgroundColor = UIColor.replyOutgoing
            replyDocumentStackView.backgroundColor = UIColor.replyOutgoing
            replyAudioView.backgroundColor = UIColor.replyOutgoing
            leftVerticalView.backgroundColor = senderName.getUIcolor()
            senderLabel.textColor = senderName.getUIcolor()
        } else {
            groupSenderLabel.showOrHide(isHide: true)
            containerLeftConstraint?.constant = 5
            containerRightConstraint?.constant = -5
            innerView.backgroundColor = UIColor.replyIncoming
            replyDocumentStackView.backgroundColor = UIColor.replyIncoming
            replyAudioView.backgroundColor = UIColor.replyIncoming
            leftVerticalView.backgroundColor = senderName.getUIcolor()
            senderLabel.textColor = senderName.getUIcolor()
        }
        self.layoutIfNeeded()
        
        //OLD MESSAGE DETAILS
        self.mediaImageView.showOrHide(isHide: true)
        
        switch message.kind {
        case .reply(let item):
            print("is current sender : \(isCurrentUser)")
            guard let parentMessage = (message as? MessageMO)?.parentMO else { return }
            let parentMessageType = parentMessage.typeDB.getMessageKind(object: parentMessage)
            print(parentMessage)
            switch parentMessageType {
            case .text(let text):
                self.iconView.showOrHide(isHide: true)
                self.messageLabel.text = text//oldBodyText
            case .photo(let rItem):
                self.mediaImageView.showOrHide(isHide: false)
                self.iconView.showOrHide(isHide: true)
                self.iconView.image = UIImage(named: "lastMesgPhoto")
                self.mediaImageView.image = rItem.image
                self.messageLabel.text = ((rItem.text ?? "").isEmpty ? "Photo": rItem.text ?? "Photo")
            case .video(let rItem):
                self.mediaImageView.showOrHide(isHide: false)
                self.iconView.showOrHide(isHide: true)
                self.iconView.image = UIImage(named: "lastMesgVideo")
                self.mediaImageView.image = rItem.image
                self.messageLabel.text = ((rItem.text ?? "").isEmpty ? "Video": rItem.text ?? "Video")
            case .audio(let rItem):
                self.iconView.showOrHide(isHide: true)
                self.iconView.image = UIImage(named: "lastMesgAudio")
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
                self.iconView.showOrHide(isHide: true)
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
            playButtonView.isHidden = true
            errorImageView.isHidden = true
            setProgress(progress: 0.0)

            let replyText = item.text ?? ""
            switch item.replyKind {
            case .text, .attributedText:
                replyMessageLabel.showOrHide(isHide: replyText.isEmpty)
                replyMessageLabel.text = replyText
            case .photo:
                setImageVideoUI(isImage: true, replyText: replyText, item: item, messageBody: messageBody)
            case .video:
                setImageVideoUI(isImage: false, replyText: replyText, item: item, messageBody: messageBody)
            case .document:
                replyDocumentStackView.showOrHide(isHide: false)
                if let url = item.url {
                    self.replyDocumentPictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: url.lastPathComponent)
                    self.replyDocumentNameLabel.text = url.lastPathComponent
                    self.replyDocumentSizeLabel.text = url.fileSizeString + "  " + url.pathExtension.uppercased()
                } else {
                    self.replyDocumentNameLabel.text = "unknown"
                    self.replyDocumentPictureView.image = QLPreviewHelper.getDocThumbnail(docUrl: nil, fileName: "txt")
                    self.replyDocumentSizeLabel.text = "0.0 B   Unknown"
                }
            case .audio:
                guard let audioURL = item.url else { return }
                self.replyAudioView.showOrHide(isHide: false)
                let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
//                replyAudioProgressView.tintColor = tintColor
                replyAudioDurationLabel.textColor = tintColor
                let audioAsset = AVURLAsset.init(url: audioURL, options: nil)
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
                            returnValue = String(format: "00:%.02d", Int(durationInSeconds.rounded(.down)))
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
                break
            default: break
            }
        default:
            break
        }
        self.layoutIfNeeded()
    }
    
    private func setImageVideoUI(isImage: Bool = true, replyText: String = "", item: ReplyItem, messageBody: String = "") {
        replyImageView.showOrHide(isHide: false)
        playButtonView.isHidden = isImage
        if replyText.isEmpty {
            replyMessageLabel.showOrHide(isHide: true)
        } else {
            replyMessageLabel.showOrHide(isHide: false)
        }
        replyMessageLabel.text = replyText
        if isImage {
            replyImageView.sd_setImage(with: item.url, placeholderImage: item.image ?? item.placeholderImage, options: .refreshCached, completed: nil)
        } else {
            if !messageBody.isEmpty, let url = FileTransferManager.getfileUrlFromName(fileName: messageBody), let objImage = FileManager().getThumbnailFromVideo(url) {
                replyImageView.image = objImage
            } else {
                replyImageView.image = item.image ?? item.placeholderImage
            }
//            var isFileExisted = false
//            if let fileURL = FileTransferManager.getfileUrlFromName(fileName: messageBody), FileManager.default.fileExists(atPath: fileURL.path), AVAsset(url: fileURL).isPlayable == true {
//                isFileExisted = true
//            } else {
//                //print(.DEBUG,"Not found")
//            }
        }
    }
    
    private func setProgress(progress: Float?) {
        guard let currentProgress = progress else {
            indicatorView.isHidden = true
            return
        }
        indicatorView.isHidden = false
        indicatorView.progress = currentProgress
        indicatorView.onCompletionOfProgress = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.indicatorView.isHidden = true
        }
        if currentProgress >= 1.0 || currentProgress <= 0.0 {
            indicatorView.isHidden = true
        }
    }
}
