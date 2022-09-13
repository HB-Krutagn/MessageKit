//
//  HBProgressViewDelegate.swift
//  qtconnect
//
//  Created by hb on 13/09/22.
//

import Foundation
import MessageKit

public protocol HBProgressViewDelegate {
    func didTapCancelProgress(in cell: MessageCollectionViewCell)
    func didTapRetryProgress(in cell: MessageCollectionViewCell)
}

extension HBProgressViewDelegate {
    public func didTapCancelProgress(in cell: MessageCollectionViewCell) { }
    public func didTapRetryProgress(in cell: MessageCollectionViewCell) { }
}
