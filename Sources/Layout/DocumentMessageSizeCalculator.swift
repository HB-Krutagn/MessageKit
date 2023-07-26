//
//  DocumentMessageSizeCalculator.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import Foundation

open class DocumentMessageSizeCalculator: MessageSizeCalculator {
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        switch message.kind {
        case .document(let item):
            let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
            if maxWidth < item.size.width {
                // Maintain the ratio if width is too great
               var height = maxWidth * item.size.height / item.size.width
              
                let font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
                 var height1 = self.heightForView(text: (item.text ?? ""), font: font, width: item.size.width) + 10.0
                if item.text == "" {
                    height1 = 0
                }
                
                return CGSize(width: maxWidth, height: height + height1 )
            }
            let font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
             var height1 = self.heightForView(text: (item.text ?? ""), font: font, width: item.size.width)
            if item.text == "" {
                height1 = 0
            }
            
            return CGSize(width: item.size.width, height: item.size.height + height1)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [.font: font])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: .greatestFiniteMagnitude), nil)
        return size.height
    }
}
