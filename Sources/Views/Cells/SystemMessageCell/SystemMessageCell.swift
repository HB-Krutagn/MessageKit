//
//  SystemMessageCell.swift
//  qtconnect
//
//  Created by hb on 17/08/22.
//

import UIKit

open class SystemMessageCell: UICollectionViewCell {
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
