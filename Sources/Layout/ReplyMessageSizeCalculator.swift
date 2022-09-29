//
//  ReplyMessageSizeCalculator.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import UIKit
import Foundation

open class ReplyMessageSizeCalculator: MessageSizeCalculator {
    
    public var incomingMessageLabelInsets = UIEdgeInsets(top: 5, left: 5 + 5 + 5, bottom: 5, right: 7 + 5)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 5, left: 7 + 5, bottom: 5, right: 5 + 5 + 5)
    public var messageLabelFont =  UIFont.systemFont(ofSize: 16.0, weight: .regular)//UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0)!
//    open lazy var replyMessageSizeCalculator = ReplyMessageSizeCalculator(layout: self)
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        var lHeight: CGFloat = 0
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
        switch message.kind {
        case .reply(let item):
            switch item.replyKind {
            case .text:
                if !(item.text ?? "").isEmpty {
                    let font = UIFont.systemFont(ofSize: 16.0, weight: .regular) //UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0 : 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    lHeight += heightForView(text: (item.text ?? ""), font: font, width: maxWidth) + 5.0
                    return CGSize(width: getMaxWidthForTextMessageType(for: message, at: indexPath, text: item.text ?? ""), height: 80 + lHeight)
                } else {
                    return CGSize(width: maxWidth, height: 95 + lHeight)
                }
            case .photo, .video:
                var captionHeight: CGFloat = 0
                if !(item.text ?? "").isEmpty {
                    let font = UIFont.systemFont(ofSize: 16.0, weight: .regular)//UIFont(name: FontName.Regular.rawValue, size: IS_iPAD ? 18.0: 16.0) ?? .systemFont(ofSize: IS_iPAD ? 18.0: 16.0)
                    captionHeight = heightForView(text: (item.text ?? ""), font: font, width: 240) + 10.0
                    return CGSize(width: 240, height: 60 + 240 + captionHeight + lHeight)
                } else {
                    return CGSize(width: 240, height: 60 + 240 + lHeight)
                }
            case .document:
                return CGSize(width: 250, height: 70 + 60 + lHeight)
            case .audio:
                return CGSize(width: 250, height: 70 + 60 + lHeight)
            default:
                return CGSize(width: maxWidth, height: 120 + lHeight)
            }
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
            label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)//UIFont(name: FontName.Semibold.rawValue, size: IS_iPAD ? 14.0: 12.0)
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
                return 150
            case .photo( _):
                return 150
            case .video( _):
                return 150
            case .audio( _):
                return 150
            case .document( _):
                return 150
            default:
                return 150
            }
        default:
            break
        }
        return 150
    }
        
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [.font: font])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
        return size.height
    }

}
