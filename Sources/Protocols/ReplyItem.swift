//
//  ReplyItem.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import Foundation

/// A protocol used to represent the data for a reply message.
public protocol ReplyItem {

    /// The text where the caption is.
    var text: String? { get }

    /// The url where the media is located.
    var url: URL? { get }

    /// The image.
    var image: UIImage? { get }
    
    /// The attachment type
    var itemType: String? { get }
    
    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }

    /// The size of the media item.
    var size: CGSize { get }
    
    var replyKind: MessageKind { get }
}
