// MIT License
//
// Copyright (c) 2017-2022 MessageKit
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

import Foundation
import UIKit

// MARK: - MessageSizeCalculator

open class MessageSizeCalculator: CellSizeCalculator {
  // MARK: Lifecycle

  public init(layout: MessagesCollectionViewFlowLayout? = nil) {
    super.init()

    self.layout = layout
  }

  // MARK: Open

  open override func configure(attributes: UICollectionViewLayoutAttributes) {
    guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

    let dataSource = messagesLayout.messagesDataSource
    let indexPath = attributes.indexPath
    let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
          if let cachedAttributes = MessagesViewController.share.attributesCache[indexPath]{
          attributes.avatarSize = cachedAttributes.avatarSize
          attributes.avatarPosition =  cachedAttributes.avatarPosition
          attributes.avatarLeadingTrailingPadding = cachedAttributes.avatarLeadingTrailingPadding

          attributes.messageContainerPadding =  cachedAttributes.messageContainerPadding
          attributes.messageContainerSize = cachedAttributes.messageContainerSize
            switch message.kind{
            case .text(let text):
                attributes.messageContainerMaxWidth = cachedAttributes.messageContainerMaxWidth
            default:
                attributes.messageContainerMaxWidth = 0.0
            }
          attributes.isBubbleView =  cachedAttributes.isBubbleView
          attributes.cellTopLabelSize =  cachedAttributes.cellTopLabelSize
          attributes.cellTopLabelAlignment =  cachedAttributes.cellTopLabelAlignment
          attributes.cellBottomLabelSize =  cachedAttributes.cellBottomLabelSize
          attributes.messageTimeLabelSize = cachedAttributes.messageTimeLabelSize
          attributes.cellBottomLabelAlignment =  cachedAttributes.cellBottomLabelAlignment
          attributes.messageTopLabelSize = cachedAttributes.messageTopLabelSize
          attributes.messageTopLabelAlignment = cachedAttributes.messageTopLabelAlignment
          attributes.cellBottomLabelAlignment = cachedAttributes.cellBottomLabelAlignment
          // messageTopLabelAlignment(for: message, at: indexPath)

          attributes.messageBottomLabelAlignment = cachedAttributes.messageBottomLabelAlignment
          attributes.messageBottomLabelSize = cachedAttributes.messageBottomLabelSize

          attributes.accessoryViewSize = cachedAttributes.accessoryViewSize
          attributes.accessoryViewPadding = cachedAttributes.accessoryViewPadding
          attributes.accessoryViewPosition = cachedAttributes.accessoryViewPosition
      }else{
          attributes.avatarSize = avatarSize(for: message, at: indexPath)
          attributes.avatarPosition = avatarPosition(for: message)
          attributes.avatarLeadingTrailingPadding = avatarLeadingTrailingPadding

          attributes.messageContainerPadding = messageContainerPadding(for: message)
          attributes.messageContainerSize = messageContainerSize(for: message, at: indexPath)
            switch message.kind{
            case .text(let text):
                attributes.messageContainerMaxWidth = messageContainerMaxWidth(for: message, at: indexPath)
            default:
                attributes.messageContainerMaxWidth = 0.0
            }
          attributes.isBubbleView = isPreviousMessageSameSender(messagesDataSource: dataSource, at: indexPath)
          attributes.cellTopLabelSize = cellTopLabelSize(for: message, at: indexPath)
          attributes.cellTopLabelAlignment = cellTopLabelAlignment(for: message)
          attributes.cellBottomLabelSize = cellBottomLabelSize(for: message, at: indexPath)
          attributes.messageTimeLabelSize = messageTimeLabelSize(for: message, at: indexPath)
          attributes.cellBottomLabelAlignment = cellBottomLabelAlignment(for: message)
          attributes.messageTopLabelSize = messageTopLabelSize(for: message, at: indexPath)
          attributes.messageTopLabelAlignment = messageTopLabelAlignment(for: message, at: indexPath)
          attributes.cellBottomLabelAlignment = cellBottomLabelAlignment(for: message)
          // messageTopLabelAlignment(for: message, at: indexPath)

          attributes.messageBottomLabelAlignment = messageBottomLabelAlignment(for: message, at: indexPath)
          attributes.messageBottomLabelSize = messageBottomLabelSize(for: message, at: indexPath)

          attributes.accessoryViewSize = accessoryViewSize(for: message)
          attributes.accessoryViewPadding = accessoryViewPadding(for: message)
          attributes.accessoryViewPosition = accessoryViewPosition(for: message)
          MessagesViewController.share.clearCache()
          MessagesViewController.share.attributesCache[attributes.indexPath] = attributes
      }
  }

  open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
    let dataSource = messagesLayout.messagesDataSource
    let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
    let itemHeight = cellContentHeight(for: message, at: indexPath)
    return CGSize(width: messagesLayout.itemWidth, height: itemHeight)
  }

  open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
    let messageContainer = messageContainerSize(for: message, at: indexPath)
    let cellBottomLabel = cellBottomLabelSize(for: message, at: indexPath)
    let messageBottomLabelHeight = messageBottomLabelSize(for: message, at: indexPath).height
      var height = 0.0
      var maxWidth = 0.0
      switch message.kind{
      case .text(let text):
          maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
      default:
          maxWidth = 0.0
      }
     
      if messageContainer.width < maxWidth {
          if (maxWidth - messageContainer.width) > cellBottomLabel.width {
             height = 15
          }
      }
      
    let cellTopLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
    let messageTopLabelHeight = messageTopLabelSize(for: message, at: indexPath).height
    let messageVerticalPadding = messageContainerPadding(for: message).vertical
    let avatarHeight = avatarSize(for: message, at: indexPath).height
    let avatarVerticalPosition = avatarPosition(for: message).vertical
    let accessoryViewHeight = accessoryViewSize(for: message).height

    switch avatarVerticalPosition {
    case .messageCenter:
      let totalLabelHeight: CGFloat = cellTopLabelHeight + messageTopLabelHeight
        + messageContainer.height + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabel.height
      let cellHeight = max(avatarHeight, totalLabelHeight)
      return max(cellHeight, accessoryViewHeight)
    case .messageBottom:
      var cellHeight: CGFloat = 0
      cellHeight += messageBottomLabelHeight
        cellHeight += cellBottomLabel.height
        let labelsHeight = messageContainer.height + messageVerticalPadding + cellTopLabelHeight + messageTopLabelHeight
      cellHeight += max(labelsHeight, avatarHeight)
      return max(cellHeight, accessoryViewHeight)
    case .messageTop:
      var cellHeight: CGFloat = 0
      cellHeight += cellTopLabelHeight
      cellHeight += messageTopLabelHeight
        let labelsHeight = messageContainer.height + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabel.height
      cellHeight += max(labelsHeight, avatarHeight)
      return max(cellHeight, accessoryViewHeight)
    case .messageLabelTop:
      var cellHeight: CGFloat = 0
      cellHeight += cellTopLabelHeight
        let messageLabelsHeight = messageContainer.height + messageBottomLabelHeight + messageVerticalPadding +
        messageTopLabelHeight + cellBottomLabel.height
      cellHeight += max(messageLabelsHeight, avatarHeight)
      return max(cellHeight, accessoryViewHeight)
    case .cellTop, .cellBottom:
      let totalLabelHeight: CGFloat = cellTopLabelHeight + messageTopLabelHeight
        + messageContainer.height + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabel.height - height
      let cellHeight = max(avatarHeight, totalLabelHeight)
      return max(cellHeight, accessoryViewHeight)
    }
  }

  // MARK: - Avatar

  open func avatarPosition(for message: MessageType) -> AvatarPosition {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    var position = isFromCurrentSender ? outgoingAvatarPosition : incomingAvatarPosition

    switch position.horizontal {
    case .cellTrailing, .cellLeading:
      break
    case .natural:
      position.horizontal = isFromCurrentSender ? .cellTrailing : .cellLeading
    }
    return position
  }

  open func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let layoutDelegate = messagesLayout.messagesLayoutDelegate
    let collectionView = messagesLayout.messagesCollectionView
    if let size = layoutDelegate.avatarSize(for: message, at: indexPath, in: collectionView) {
      return size
    }
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingAvatarSize : incomingAvatarSize
  }

  // MARK: - Top cell Label

  open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let layoutDelegate = messagesLayout.messagesLayoutDelegate
    let collectionView = messagesLayout.messagesCollectionView
    let height = layoutDelegate.cellTopLabelHeight(for: message, at: indexPath, in: collectionView)
    return CGSize(width: messagesLayout.itemWidth, height: height)
  }
    func isPreviousMessageSameSender(messagesDataSource:MessagesDataSource,at indexPath: IndexPath) -> Bool {
        guard indexPath.row - 1 >= 0 else { return false }
        
        let preIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        let preMessage = messagesDataSource.messageForItem(at: preIndexPath, in: messagesLayout.messagesCollectionView)
        let abc = preMessage
        switch abc.kind {
        case .systemMessage:
            return false
        default:
//            if message.sender.senderId == preMessage.sender.senderId{
//                return message.isIncoming == preMessage.
//                }
//                return false
            return message.sender.senderId == preMessage.sender.senderId
        }
    }
  open func cellTopLabelAlignment(for message: MessageType) -> LabelAlignment {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingCellTopLabelAlignment : incomingCellTopLabelAlignment
  }

  // MARK: - Top message Label

 open func messageTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let layoutDelegate = messagesLayout.messagesLayoutDelegate
    let collectionView = messagesLayout.messagesCollectionView
    let height = layoutDelegate.messageTopLabelHeight(for: message, at: indexPath, in: collectionView)
      let dataSource = messagesLayout.messagesDataSource
      guard let attributedText = dataSource.messageTopLabelAttributedText(for: message, at: indexPath) else {
        return CGSize(width: messagesLayout.itemWidth, height: height)
      }
      let size = attributedText.size()
      return CGSize(width: size.width + 10, height: height)
  }
  open func messageTopLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
    let collectionView = messagesLayout.messagesCollectionView
    let layoutDelegate = messagesLayout.messagesLayoutDelegate

    if let alignment = layoutDelegate.messageTopLabelAlignment(for: message, at: indexPath, in: collectionView) {
      return alignment
    }

    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingMessageTopLabelAlignment : incomingMessageTopLabelAlignment
  }

  // MARK: - Message time label

  open func messageTimeLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let dataSource = messagesLayout.messagesDataSource
    guard let attributedText = dataSource.messageTimestampLabelAttributedText(for: message, at: indexPath) else {
      return .zero
    }
    let size = attributedText.size()
    return CGSize(width: size.width, height: size.height)
  }

  // MARK: - Bottom cell Label

open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let layoutDelegate = messagesLayout.messagesLayoutDelegate
    let collectionView = messagesLayout.messagesCollectionView
    let height = layoutDelegate.cellBottomLabelHeight(for: message, at: indexPath, in: collectionView)
     
      let dataSource = messagesLayout.messagesDataSource
      guard let attributedText = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath) else {
        return .zero
      }
      let size = attributedText.size()
    return CGSize(width: size.width + 10, height: height)
  }

  open func cellBottomLabelAlignment(for message: MessageType) -> LabelAlignment {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
     return outgoingCellBottomLabelAlignment
    // return isFromCurrentSender ? outgoingCellBottomLabelAlignment : incomingCellBottomLabelAlignment
  }

  // MARK: - Bottom Message Label

  open func messageBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let layoutDelegate = messagesLayout.messagesLayoutDelegate
    let collectionView = messagesLayout.messagesCollectionView
    let height = layoutDelegate.messageBottomLabelHeight(for: message, at: indexPath, in: collectionView)
    return CGSize(width: messagesLayout.itemWidth, height: height)
  }

  open func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath) -> LabelAlignment {
    let collectionView = messagesLayout.messagesCollectionView
    let layoutDelegate = messagesLayout.messagesLayoutDelegate

    if let alignment = layoutDelegate.messageBottomLabelAlignment(for: message, at: indexPath, in: collectionView) {
      return alignment
    }

    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingMessageBottomLabelAlignment : incomingMessageBottomLabelAlignment
  }

  // MARK: - MessageContainer

  open func messageContainerPadding(for message: MessageType) -> UIEdgeInsets {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
  }

  open func messageContainerSize(for _: MessageType, at _: IndexPath) -> CGSize {
    // Returns .zero by default
    .zero
  }

  open func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
    let avatarWidth: CGFloat = avatarSize(for: message, at: indexPath).width
    let messagePadding = messageContainerPadding(for: message)
    let accessoryWidth = accessoryViewSize(for: message).width
    let accessoryPadding = accessoryViewPadding(for: message)
    return messagesLayout.itemWidth - avatarWidth - messagePadding.horizontal - accessoryWidth - accessoryPadding
      .horizontal - avatarLeadingTrailingPadding
  }

  // MARK: Public

  public var incomingAvatarSize = CGSize(width: 30, height: 30)
  public var outgoingAvatarSize = CGSize(width: 30, height: 30)

  public var incomingAvatarPosition = AvatarPosition(vertical: .cellBottom)
  public var outgoingAvatarPosition = AvatarPosition(vertical: .cellBottom)

  public var avatarLeadingTrailingPadding: CGFloat = 0

  public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
  public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

  public var incomingCellTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
  public var outgoingCellTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)

  public var incomingCellBottomLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
  // public var outgoingCellBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))
   public var outgoingCellBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10))

  public var incomingMessageTopLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
  public var outgoingMessageTopLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

  public var incomingMessageBottomLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
  public var outgoingMessageBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

  public var incomingAccessoryViewSize = CGSize.zero
  public var outgoingAccessoryViewSize = CGSize.zero

  public var incomingAccessoryViewPadding = HorizontalEdgeInsets.zero
  public var outgoingAccessoryViewPadding = HorizontalEdgeInsets.zero

  public var incomingAccessoryViewPosition: AccessoryPosition = .messageCenter
  public var outgoingAccessoryViewPosition: AccessoryPosition = .messageCenter

  // MARK: - Helpers

  public var messagesLayout: MessagesCollectionViewFlowLayout {
    guard let layout = layout as? MessagesCollectionViewFlowLayout else {
      fatalError("Layout object is missing or is not a MessagesCollectionViewFlowLayout")
    }
    return layout
  }

  // MARK: - Accessory View

  public func accessoryViewSize(for message: MessageType) -> CGSize {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingAccessoryViewSize : incomingAccessoryViewSize
  }

  public func accessoryViewPadding(for message: MessageType) -> HorizontalEdgeInsets {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingAccessoryViewPadding : incomingAccessoryViewPadding
  }

  public func accessoryViewPosition(for message: MessageType) -> AccessoryPosition {
    let dataSource = messagesLayout.messagesDataSource
    let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
    return isFromCurrentSender ? outgoingAccessoryViewPosition : incomingAccessoryViewPosition
  }

  // MARK: Internal

  public func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
    let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
    let rect = attributedText.boundingRect(
      with: constraintBox,
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil).integral

    return rect.size
  }
}

extension UIEdgeInsets {
  fileprivate init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
    self.init(top: top, left: left, bottom: bottom, right: right)
  }
}
