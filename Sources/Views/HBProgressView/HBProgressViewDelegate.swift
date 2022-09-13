//
//  HBProgressViewDelegate.swift
//  qtconnect
//
//  Created by hb on 13/09/22.
//

import Foundation

public protocol HBProgressViewDelegate: class {
    func didTapCancelProgress(in cell: MessageCollectionViewCell)
    func didTapRetryProgress(in cell: MessageCollectionViewCell)
}

extension HBProgressViewDelegate {
    public func didTapCancelProgress(in cell: MessageCollectionViewCell) { }
    public func didTapRetryProgress(in cell: MessageCollectionViewCell) { }
}
