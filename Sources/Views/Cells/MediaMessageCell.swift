// MIT License
//
// Copyright (c) 2017-2019 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import MaterialComponents.MaterialActivityIndicator

/// A subclass of `MessageContentCell` used to display video and audio messages.
open class MediaMessageCell: MessageContentCell {
    /// The play button view to display on video messages.
    open lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()
    
    /// The image view display the media content.
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    open lazy var messageProgressView: HBProgressView = {
        let progressView = HBProgressView()
        progressView.clipsToBounds = true
        progressView.layer.masksToBounds = true
        return progressView
    }()
   
    open lazy var captionLabel: MessageLabel = {
        let captionLabel = MessageLabel()
        captionLabel.lineBreakMode = .byWordWrapping
        captionLabel.backgroundColor = .clear
        captionLabel.textAlignment = .left
        captionLabel.textColor = .black
        captionLabel.text = ""
        captionLabel.numberOfLines = 0
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
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
    
    open var progressIndicatorRadius: CGFloat = 25 {
        didSet {
            messageProgressView.indicatorRadius = progressIndicatorRadius
        }
    }
    
    open var progressIndicatorStrockWidth: CGFloat = 5.0 {
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
//        imageView.fillSuperview()
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 35, height: 35))
        messageProgressView.centerInSuperview()
        messageProgressView.constraint(equalTo: CGSize(width: 56, height: 56))
        messageProgressView.layer.cornerRadius = 28
        messageProgressView.btnRetry.centerInSuperview()
        messageProgressView.btnRetry.constraint(equalTo: CGSize(width: 50, height: 50))
    }
    open override func setupSubviews() {
        super.setupSubviews()
    
        imageView.addSubview(playButtonView)
        imageView.addSubview(messageProgressView)
        imageView.heightAnchor.constraint(equalToConstant:240).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 1.0
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(captionLabel)
        messageContainerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addConstraints(messageContainerView.topAnchor,left: messageContainerView.leftAnchor,bottom: messageContainerView.bottomAnchor,right: messageContainerView.rightAnchor, topConstant: 5,leftConstant: 5,bottomConstant: 5,rightConstant: 5)
        setProgressViewConfig()
        messageProgressView.isHidden = true
        setupConstraints()
    }
//    open override func setupSubviews() {
//        super.setupSubviews()
//        messageContainerView.addSubview(imageView)
//        messageContainerView.addSubview(playButtonView)
//        messageContainerView.addSubview(messageProgressView)
//        setProgressViewConfig()
//        messageProgressView.isHidden = true
//        setupConstraints()
//    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setProgressViewConfig() {
        messageProgressView.indicatorMode = progressIndicatorMode
        messageProgressView.indicatorRadius = progressIndicatorRadius
        messageProgressView.indicatorStrockWidth = progressIndicatorStrockWidth
        messageProgressView.indicatorColor = progressIndicatorColor
        messageProgressView.indicatorTrackEnabled = progressIndicatorTrackEnabled
    }
    
    open override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        switch message.kind {
        case .photo(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.isHidden = true
            progressPercentage = mediaItem.mediaProgress
            captionLabel.text = mediaItem.text
        case .video(let mediaItem):
            imageView.image = mediaItem.image ?? mediaItem.placeholderImage
            playButtonView.isHidden = false
            progressPercentage = mediaItem.mediaProgress
            captionLabel.text = mediaItem.text
        default:
            break
        }
        displayDelegate.configureMediaMessageImageView(imageView, for: message, at: indexPath, in: messagesCollectionView)
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
                let touchLocation = gesture.location(in: imageView)
                guard imageView.frame.contains(touchLocation) else {
                    super.handleTapGesture(gesture)
                    return
                }
                delegate?.didTapImage(in: self)
            }
        } else {
            let touchLocation = gesture.location(in: imageView)
            guard imageView.frame.contains(touchLocation) else {
                super.handleTapGesture(gesture)
                return
            }
            delegate?.didTapImage(in: self)
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
