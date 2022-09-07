//
//  DocumentMessageSizeCalculator.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import Foundation

open class DocumentMessageSizeCalculator: MessageSizeCalculator {

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        switch message.kind {
        case .document(let item):
            let maxWidth = messageContainerMaxWidth(for: message)
            if maxWidth < item.size.width {
                // Maintain the ratio if width is too great
                let height = maxWidth * item.size.height / item.size.width
                return CGSize(width: maxWidth, height: height)
            }
            return CGSize(width: item.size.width, height: item.size.height)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
}
