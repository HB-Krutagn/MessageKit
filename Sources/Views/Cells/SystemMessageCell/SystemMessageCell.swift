//
//  SystemMessageCell.swift
//  qtconnect
//
//  Created by hb on 17/08/22.
//

import UIKit
import Foundation
open class SystemMessageCell: UICollectionViewCell {    
    static let bundle = Bundle(for: SystemMessageCell.self)
    static let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)

    @IBOutlet weak var lblMessage: PaddingLabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessage.layer.cornerRadius = 6
        lblMessage.clipsToBounds = true
    }
    
    open func configure(with message: MessageType, at _: IndexPath, and _: MessagesCollectionView) {
        // Do stuff
        switch message.kind {
        case .systemMessage(let data):
            if let systemMessage = data as? String {
                lblMessage.text = systemMessage
            } else if let systemMessage = data as? NSAttributedString {
                lblMessage.attributedText = systemMessage
            } else {
                return
            }
        default:
            break
        }
    }
}
