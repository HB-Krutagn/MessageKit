//
//  URL+Extension.swift
//  QTConnect
//
//  Created by hb on 09/09/22.
//  Copyright © 2022 QT. All rights reserved.
//

import Foundation

extension URL {
    var uti: String {
        return (try? self.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier ?? "public.data"
    }
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .binary)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
