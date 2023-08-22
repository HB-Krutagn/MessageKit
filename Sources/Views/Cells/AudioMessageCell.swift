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

import AVFoundation
import UIKit
import AVKit
import MaterialComponents.MaterialActivityIndicator
/// A subclass of `MessageContentCell` used to display video and audio messages.
open class AudioMessageCell: MessageContentCell {
  // MARK: Open

  /// Responsible for setting up the constraints of the cell's subviews.
  open func setupConstraints() {
    playButton.constraint(equalTo: CGSize(width: 35, height: 35))
    playButton.addConstraints(
      left: messageContainerView.leftAnchor,
      centerY: messageContainerView.centerYAnchor,
      leftConstant: 5)
//    activityIndicatorView.addConstraints(centerY: playButton.centerYAnchor, centerX: playButton.centerXAnchor)
      
    activityIndicatorView.addConstraints(left: playButton.leftAnchor, centerY: playButton.centerYAnchor, leftConstant: -2.5)
    activityIndicatorView.constraint(equalTo: CGSize(width: 40, height: 40))
    activityIndicatorView.layer.cornerRadius = 20
      
    activityIndicatorView.activityIndicator.centerInSuperview()
    activityIndicatorView.activityIndicator.constraint(equalTo: CGSize(width: 35, height: 35))

    activityIndicatorView.btnRetry.centerInSuperview()
    activityIndicatorView.btnRetry.constraint(equalTo: CGSize(width: 35, height: 35))
      
    durationLabel.addConstraints(
      right: messageContainerView.rightAnchor,
      centerY: messageContainerView.centerYAnchor,
      rightConstant: 15)
    progressView.addConstraints(
      left: playButton.rightAnchor,
      right: durationLabel.leftAnchor,
      centerY: messageContainerView.centerYAnchor,
      leftConstant: 5,
      rightConstant: 5)
  }

  open override func setupSubviews() {
    super.setupSubviews()
    messageContainerView.addSubview(playButton)
    messageContainerView.addSubview(activityIndicatorView)
    messageContainerView.addSubview(durationLabel)
    messageContainerView.addSubview(progressView)
    setupConstraints()
    setProgressViewConfig()
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    progressView.progress = 0
    playButton.isSelected = false
    playButton.isHidden = false
    durationLabel.text = "00:00"
  }

  /// Handle tap gesture on contentView and its subviews.
  open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
    let touchLocation = gesture.location(in: self)
    // compute play button touch area, currently play button size is (25, 25) which is hardly touchable
    // add 10 px around current button frame and test the touch against this new frame
    let playButtonTouchArea = CGRect(
      playButton.frame.origin.x - 10.0,
      playButton.frame.origin.y - 10,
      playButton.frame.size.width + 20,
      playButton.frame.size.height + 20)
    let translateTouchLocation = convert(touchLocation, to: messageContainerView)
    if playButtonTouchArea.contains(translateTouchLocation) {
      delegate?.didTapPlayButton(in: self)
    } else {
      super.handleTapGesture(gesture)
    }
  }

  // MARK: - Configure Cell

  open override func configure(
    with message: MessageType,
    at indexPath: IndexPath,
    and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        
        let playButtonLeftConstraint = messageContainerView.constraints.filter { $0.identifier == "left" }.first
        let durationLabelRightConstraint = messageContainerView.constraints.filter { $0.identifier == "right" }.first
        
       switch self.bubbleView.style {
            case .bubbleTail:
                if !dataSource.isFromCurrentSender(message: message) {
                    playButtonLeftConstraint?.constant = 15
                    durationLabelRightConstraint?.constant = -8
                } else {
                    playButtonLeftConstraint?.constant = 6
                    durationLabelRightConstraint?.constant = -15
                }
            default:
                if !dataSource.isFromCurrentSender(message: message) {
                    playButtonLeftConstraint?.constant = 6
                    durationLabelRightConstraint?.constant = -8
                } else {
                    playButtonLeftConstraint?.constant = 6
                    durationLabelRightConstraint?.constant = -8
                }
            }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        
        let tintColor = displayDelegate.audioTintColor(for: message, at: indexPath, in: messagesCollectionView)
        durationLabel.textColor = tintColor
        //    playButton.imageView?.tintColor = tintColor
        //    progressView.tintColor = tintColor
        
        if case .audio(let audioItem) = message.kind {
            setDurationOfAudio(audioURL: audioItem.url)
            progressPercentage = audioItem.mediaProgress
            //            let _ = displayDelegate.audioProgressTextFormat(audioItem.duration, for: self, in: messagesCollectionView)
        }
    }

    func setDurationOfAudio(audioURL: URL) {
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
                    returnValue = String(format: "00:%.02d", Int(durationInSeconds.rounded(.up)))
                } else if durationInSeconds < 3600 {
                    returnValue = String(format: "%.02d:%.02d", Int(durationInSeconds/60), Int(durationInSeconds) % 60)
                } else {
                    let hours = Int(durationInSeconds/3600)
                    let remainingMinutesInSeconds = Int(durationInSeconds) - hours*3600
                    returnValue = String(format: "%.02d:%.02d:%.02d", hours, Int(remainingMinutesInSeconds/60), Int(remainingMinutesInSeconds) % 60)
                }
                DispatchQueue.main.async {
                    self.durationLabel.text = returnValue
                }
                break
            case .failed:
                break // Handle error
            case .cancelled:
                break // Terminate processing
            default:
                break // Handle all other cases
            }
        }
    }

  // MARK: Public

  /// The play button view to display on audio messages.
  public lazy var playButton: UIButton = {
    let playButton = UIButton(type: .custom)
    let playImage = UIImage.messageKitImageWith(type: .audioPlay)?.withTintColor(.white)
    let pauseImage = UIImage.messageKitImageWith(type: .audioPause)?.withTintColor(.white)
    playButton.setImage(playImage, for: .normal)
    playButton.setImage(pauseImage, for: .selected)
    playButton.backgroundColor = UIColor.blueThemeColor
    playButton.layer.cornerRadius = 17.5
    return playButton
  }()

  /// The time duration label to display on audio messages.
  public lazy var durationLabel: UILabel = {
    let durationLabel = UILabel(frame: CGRect.zero)
    durationLabel.textAlignment = .right
    durationLabel.font = UIFont.systemFont(ofSize: 14)
    durationLabel.text = "00:00"
    return durationLabel
  }()

  public lazy var activityIndicatorView: HBProgressView = {
    let activityIndicatorView = HBProgressView()
    activityIndicatorView.clipsToBounds = true
    activityIndicatorView.layer.masksToBounds = true
    return activityIndicatorView
  }()

  public lazy var progressView: UIProgressView = {
    let progressView = UIProgressView(progressViewStyle: .default)
    progressView.progress = 0.0
    progressView.tintColor = UIColor.blueThemeColor
    return progressView
  }()
    
    open var progressPercentage: Float? = nil {
        didSet {
            setProgress(progress: progressPercentage)
        }
    }
    
    open var progressIndicatorMode: MDCActivityIndicatorMode = .determinate {
        didSet {
            activityIndicatorView.indicatorMode = progressIndicatorMode
        }
    }
    
    open var progressIndicatorRadius: CGFloat = 17.5 {
        didSet {
            activityIndicatorView.indicatorRadius = progressIndicatorRadius
        }
    }
    
    open var progressIndicatorStrockWidth: CGFloat = 4.0 {
        didSet {
            activityIndicatorView.indicatorStrockWidth = progressIndicatorStrockWidth
        }
    }

    open var progressIndicatorColor: UIColor = .white {
        didSet {
            activityIndicatorView.indicatorColor = progressIndicatorColor
        }
    }

    open var progressIndicatorTrackEnabled: Bool = true {
        didSet {
            activityIndicatorView.indicatorTrackEnabled = progressIndicatorTrackEnabled
        }
    }

        private func setProgress(progress: Float?) {
        guard let currentProgress = progress else {
            activityIndicatorView.isHidden = true
            return
        }
        activityIndicatorView.isHidden = false
        if currentProgress == 0.0 {
            activityIndicatorView.progress = 0.01
        }else{
            activityIndicatorView.progress = currentProgress
        }
        activityIndicatorView.onCompletionOfProgress = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.activityIndicatorView.isHidden = true
        }
        if currentProgress >= 1.0 {
            activityIndicatorView.isHidden = true
        }
    }

    func setProgressViewConfig() {
        activityIndicatorView.indicatorMode = progressIndicatorMode
        activityIndicatorView.indicatorRadius = progressIndicatorRadius
        activityIndicatorView.indicatorStrockWidth = progressIndicatorStrockWidth
        activityIndicatorView.indicatorColor = progressIndicatorColor
        activityIndicatorView.indicatorTrackEnabled = progressIndicatorTrackEnabled
    }
}
