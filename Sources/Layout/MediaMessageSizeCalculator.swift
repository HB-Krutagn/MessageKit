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

import Foundation
import UIKit

open class MediaMessageSizeCalculator: MessageSizeCalculator {
  open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
    let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
    let sizeForMediaItem = { (maxWidth: CGFloat, item: MediaItem) -> CGSize in
        let font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
         var height = self.heightForView(text: (item.text ?? ""), font: font, width: item.size.width) + 10.0
        if item.text == "" {
            height = 0
        }
        if maxWidth < item.size.width {
        // Maintain the ratio if width is too great
        let height = maxWidth * item.size.height / item.size.width
        return CGSize(width: maxWidth, height: height + 100 + height)
      }
//      return item.size
        return CGSize(width: item.size.width, height: item.size.height + height )
    }
    switch message.kind {
    case .photo(let item):
      return sizeForMediaItem(maxWidth, item)
    case .video(let item):
      return sizeForMediaItem(maxWidth, item)
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
