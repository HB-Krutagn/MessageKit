//
//  QLPreviewHelper.swift
//  QTConnect
//
//  Created by Rajeev Radhakrishnan on 04/04/2019.
//  Copyright © 2019 QT. All rights reserved.
//

import Foundation
import QuickLook
import PDFKit
import MobileCoreServices
import MessageKit

class QLPreviewHelper {
    var controller: QLPreviewController
    
    init(source: QLPreviewControllerDataSource) {
        controller = QLPreviewController()
        controller.dataSource = source
    }
    
    func present(url:URL, onView view:UIViewController) {
        if QLPreviewController.canPreview(url as NSURL) {
            controller.currentPreviewItemIndex = 0
            view.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    class func getDocThumbnail(docUrl:URL?, fileName:String) -> UIImage {
        let fileExtention = NSString(string: fileName).pathExtension.lowercased()
        var extentionBasedImage:UIImage?
        if let image = UIImage.messageKitImageWith(type: fileExtention) {
            extentionBasedImage = image
        } else if fileExtention.hasPrefix("ppt") {
            extentionBasedImage = UIImage.messageKitImageWith(type: .ppt)
        } else if fileExtention.hasPrefix("doc") || fileExtention.hasPrefix("docx") {
            extentionBasedImage = UIImage.messageKitImageWith(type: .doc)
        } else if fileExtention.hasPrefix("xml") || fileExtention.hasPrefix("xls") {
            extentionBasedImage = UIImage.messageKitImageWith(type: .excel)
        } else if fileExtention.hasPrefix("mov") || fileExtention.hasPrefix("mkv") || fileExtention.hasPrefix("wmv") || fileExtention.hasPrefix("avi") {
            extentionBasedImage = UIImage.messageKitImageWith(type: .video)
        } else {
            extentionBasedImage = UIImage.messageKitImageWith(type: .unknown)
        }
        return extentionBasedImage
    }
}
