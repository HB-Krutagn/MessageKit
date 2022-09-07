//
//  ReplyMessageSizeCalculator.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import Foundation

open class ReplyMessageSizeCalculator: MessageSizeCalculator {
    public var incomingMessageLabelInsets = UIEdgeInsets(top: 5, left: 8+5+12, bottom: 5, right: 7+8)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 5, left: 7+8, bottom: 5, right: 8+5+12)
    public var messageLabelFont = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)!
    
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        var lHeight: CGFloat = 0
        let maxWidth = messageContainerMaxWidth(for: message)
        switch message.kind {
        case .reply(let item):
            if item.itemType == attachmentType.text.rawValue {
                if !(item.text ?? "").isEmpty {
                    let font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    lHeight += UILabel.heightForView(text: (item.text ?? ""), font: font, width: maxWidth) + 5.0
                    return CGSize(width: getMaxWidthForTextMessageType(for: message, text: item.text ?? ""), height: 95 + lHeight)
                } else {
                    return CGSize(width: maxWidth, height: 95 + lHeight)
                }
            } else if item.itemType == attachmentType.image.rawValue || item.itemType == attachmentType.video.rawValue {
                var captionHeight: CGFloat = 0
                if !(item.text ?? "").isEmpty {
                    let font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    captionHeight = UILabel.heightForView(text: (item.text ?? ""), font: font, width: 260) + 10.0
                    return CGSize(width: 260, height: 100+260+captionHeight + lHeight)
                } else {
                    return CGSize(width: 260, height: 100+260 + lHeight)
                }
            } else if item.itemType == attachmentType.doc.rawValue {
                return CGSize(width: 260, height: 80+60 + lHeight)
            } else if item.itemType == attachmentType.audio.rawValue {
                return CGSize(width: 260, height: 80+60 + lHeight)
            } else {}
            return CGSize(width: maxWidth, height: 120 + lHeight)//item.size
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
    
    func getMaxWidthForTextMessageType(for message: MessageType, text:String) -> CGFloat {
        
        let maxWidth = self.messageContainerMaxWidth(for: message)
        let attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        if attributedText.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return 0
        } else {
            var groupSenderLblSize:CGFloat = 0.0
            if (message.sender != SampleData.shared.currentSender) {
                if let objMessage = DatabaseInterface.shared.getMessagefromID(messageID: message.messageId) , objMessage.groupFlag {
                    groupSenderLblSize = 20.0
                }
            }
            let label: UILabel = UILabel(frame: CGRect(0, 0, maxWidth, 1))
            label.font = UIFont(name: FontName.Semibold.rawValue, size: IS_iPAD ? 14.0: 12.0)
            label.text = message.sender.displayName
            let senderLblwidth = label.intrinsicContentSize.width + 20
            
            var messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
            let messageInsets = messageLabelInsets(for: message)
            messageContainerSize.width += messageInsets.horizontal
            messageContainerSize.height += messageInsets.vertical + 15
            messageContainerSize.width = max(messageContainerSize.width , 100.0 + groupSenderLblSize)
            return max(senderLblwidth,messageContainerSize.width,getMinimumMessageWidth(message: message))
        }
    }
    
    
    open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message)
        let textInsets = messageLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }
    func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }
    func getMinimumMessageWidth(message: MessageType) -> CGFloat {
        switch message.kind {
        case .reply(let item):
            switch item.replyKind {
            case .text( _):
                return 0
            case .photo( _):
                fallthrough
            case .video( _):
                fallthrough
            case .audio( _):
                fallthrough
            case .document( _):
                return 150
            default:
                return 0
            }
        default:
            break
        }
        return 0
    }
}

