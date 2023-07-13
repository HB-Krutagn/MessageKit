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

/// A subclass of `MessageContentCell` used to display text messages.
open class TextMessageCell: MessageContentCell {
  /// The label used to display the message's text.
  open var messageLabel = MessageLabel()

  // MARK: - Properties

  /// The `MessageCellDelegate` for the cell.
  open override weak var delegate: MessageCellDelegate? {
    didSet {
      messageLabel.delegate = delegate
    }
  }

  // MARK: - Methods

  open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
      messageLabel.textInsets = attributes.messageLabelInsets
      messageLabel.messageLabelFont = attributes.messageLabelFont
      messageLabel.frame = messageContainerView.bounds
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    messageLabel.attributedText = nil
    messageLabel.text = nil
  }

  open override func setupSubviews() {
    super.setupSubviews()
    messageContainerView.addSubview(messageLabel)
  }

  open override func configure(
    with message: MessageType,
    at indexPath: IndexPath,
    and messagesCollectionView: MessagesCollectionView)
  {
    super.configure(with: message, at: indexPath, and: messagesCollectionView)

    guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
      fatalError(MessageKitError.nilMessagesDisplayDelegate)
    }

    let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

    messageLabel.configure {
      messageLabel.enabledDetectors = enabledDetectors
      for detector in enabledDetectors {
        let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
        messageLabel.setAttributes(attributes, detector: detector)
      }
      let textMessageKind = message.kind.textMessageKind
      switch textMessageKind {
      case .text(let text), .emoji(let text):
          let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageLabel.textColor = textColor
                if message.isExpanded{
                    messageLabel.text = text.getExpandText()
                    if text.count >= 350{
                        self.messageLabel.colorString(text: messageLabel.text,coloredText: String.lessText)
                    }
                    
                }else{
                    messageLabel.text = text.getCollpaseText()
                    if text.count >= 350{
                        self.messageLabel.colorString(text: messageLabel.text,coloredText: String.moreText)
                    }
                }
                if let font = messageLabel.messageLabelFont {
                    messageLabel.font = font
                }
      case .attributedText(let text):
        messageLabel.attributedText = text
      default:
        break
      }
    }
  }

  /// Used to handle the cell's contentView's tap gesture.
  /// Return false when the contentView does not need to handle the gesture.
  open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
    messageLabel.handleGesture(touchPoint)
  }
}
extension String {
    static let moreText = "see more"
    static let lessText = "see less"
    func getCollpaseText() -> String? {
        if self.count >= 350 {
            let msg = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let maxLength = 330
            let substring = String(msg.prefix(maxLength-35))
            var collapseText = substring.appending("...\n").appending(String.moreText)
            return collapseText
        }
        return self
    }
    
    func getExpandText() -> String? {
        if self.count >= 350 {
            var expandText = self.appending("\n").appending(String.lessText)
            return expandText
        }
        return self
    }
}
extension UILabel {
    func colorString(text: String?, coloredText: String?, color: UIColor? = .blue) {
        let attributedString = NSMutableAttributedString(string: text!)
        let range = (text! as NSString).range(of: coloredText!)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color!],
                                       range: range)
        self.attributedText = attributedString
    }
}
