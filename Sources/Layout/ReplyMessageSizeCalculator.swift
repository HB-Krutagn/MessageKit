//
//  ReplyMessageSizeCalculator.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import UIKit
import Foundation
import MessageKit

open class ReplyMessageSizeCalculator: MessageSizeCalculator {
    
    public var incomingMessageLabelInsets = UIEdgeInsets(top: 5, left: 8 + 5 + 12, bottom: 5, right: 7 + 8)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 5, left: 7 + 8, bottom: 5, right: 8 + 5 + 12)
    public var messageLabelFont = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)!
//    open lazy var replyMessageSizeCalculator = ReplyMessageSizeCalculator(layout: self)
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        var lHeight: CGFloat = 0
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
        switch message.kind {
        case .reply(let item):
            if item.itemType == "text" {
                if !(item.text ?? "").isEmpty {
                    let font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0 : 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    lHeight += UILabel.heightForView(text: (item.text ?? ""), font: font, width: maxWidth) + 5.0
                    return CGSize(width: getMaxWidthForTextMessageType(for: message, at: indexPath, text: item.text ?? ""), height: 95 + lHeight)
                } else {
                    return CGSize(width: maxWidth, height: 95 + lHeight)
                }
            } else if item.itemType == "image" || item.itemType == "video" {
                var captionHeight: CGFloat = 0
                if !(item.text ?? "").isEmpty {
                    let font = UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    captionHeight = UILabel.heightForView(text: (item.text ?? ""), font: font, width: 260) + 10.0
                    return CGSize(width: 260, height: 100 + 260 + captionHeight + lHeight)
                } else {
                    return CGSize(width: 260, height: 100 + 260 + lHeight)
                }
            } else if item.itemType == "document" || item.itemType == "doc" {
                return CGSize(width: 260, height: 80 + 60 + lHeight)
            } else if item.itemType == "audio" {
                return CGSize(width: 260, height: 80 + 60 + lHeight)
            } else {}
            return CGSize(width: maxWidth, height: 120 + lHeight)//item.size
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
        
    func getMaxWidthForTextMessageType(for message: MessageType, at indexPath: IndexPath, text: String) -> CGFloat {
        
        let maxWidth = self.messageContainerMaxWidth(for: message, at: indexPath)
        let attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        if attributedText.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return 0
        } else {
            var groupSenderLblSize:CGFloat = 0.0
//            if (message.sender != SampleData.shared.currentSender) {
//                if let objMessage = DatabaseInterface.shared.getMessagefromID(messageID: message.messageId) , objMessage.groupFlag {
//                    groupSenderLblSize = 20.0
//                }
//            }
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: 1))
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
    
    open override func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message, at: indexPath)
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
