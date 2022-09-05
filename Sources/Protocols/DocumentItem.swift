//
//  DocumentItem.swift
//  QTConnect
//
//  Created by HB Mac on 13/08/21.
//  Copyright © 2021 QT. All rights reserved.
//

import Foundation

/// A protocol used to represent the data for a document message.
public protocol DocumentItem {
    
    /// The text where the caption is.
    var text: String? { get }

    /// The url where the media is located.
    var url: URL? { get }

    /// The image.
    var fileSize: Int { get }

    /// The size of the media item.
    var size: CGSize { get }

}
