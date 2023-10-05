//
//  SystemMessageCell.swift
//  qtconnect
//
//  Created by hb on 17/08/22.
//

import UIKit
import Foundation
open class SystemMessageCell: MessageContentCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: PaddingLabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessage.layer.cornerRadius = 6
        lblMessage.clipsToBounds = true
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .systemMessage(let data):
            if let systemMessage = data as? String {
                lblMessage.text = systemMessage
                lblDate.isHidden = true
                if indexPath.row == 0{
                    lblDate.isHidden = false
                    lblDate.attributedText = NSAttributedString(
                        string: message.sentDate.chatDate() ?? "",
                        attributes: [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                        ])
                }
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
extension Date{
    func chatDate() -> String? {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd MMM yyyy"
        return "  " + formatter.string(from: self) + "  "
    }
}
