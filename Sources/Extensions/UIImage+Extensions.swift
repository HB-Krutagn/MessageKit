// MIT License
//
// Copyright (c) 2017-2020 MessageKit
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

// MARK: - ImageType

public enum ImageType: String {
  case play
  case pause
  case disclosure
  case ai
  case android
  case apk
  case css
  case disc
  case doc
  case excel
  case font
  case iso
  case javascript
  case jpg
  case js
  case pdf
  case php
  case powerpoint
  case ppt
  case psd
  case record
  case sql
  case svg
  case text
  case ttf
  case txt
  case unknown
  case vcf
  case vector
  case video
  case word
  case zip
  case music
  case mp3
  case mp4
  case mail
}

/// This extension provide a way to access image resources with in framework
extension UIImage {
  public static func messageKitImageWith(type: ImageType) -> UIImage? {
    UIImage(named: type.rawValue, in: Bundle.messageKitAssetBundle, compatibleWith: nil)
  }
}
