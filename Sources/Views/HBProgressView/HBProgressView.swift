//
//  HBProgressView.swift
//  qtconnect
//
//  Created by hb on 12/09/22.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator
import MessageKit

open class HBProgressView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var vwProgressContainer: UIView!
    @IBOutlet weak var activityIndicator: MDCActivityIndicator!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwRetryContainer: UIView!
    @IBOutlet weak var btnRetry: UIButton!
    
    // MARK: - Variables
    var progress: CGFloat = 0.0 {
        didSet {
            if progress >= 1 {
                btnCancel.isHidden = true
                shouldAnimate = false
            } else {
                btnCancel.isHidden = false
                activityIndicator.progress = Float(progress)
                shouldAnimate = true
            }
        }
    }
    
    var shouldAnimate: Bool = false {
        didSet {
            if shouldAnimate {
                if !activityIndicator.isAnimating {
                    activityIndicator.startAnimating()
                }
            } else {
                if activityIndicator.isAnimating {
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Default Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        nibSetup()
        createProgressView()
    }

    func nibSetup() {
        backgroundColor = .clear
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: HBProgressView.self)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
//        return nibView
    }

    // MARK: - Actions
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        print("Cancel Progress Clicked")
        shouldAnimate = false
        setVisibleView(shouldProgressVisible: false)
    }
    
    // MARK: - Custom Methods
    func createProgressView() {
        activityIndicator.radius = 25
        activityIndicator.strokeWidth = 3.0
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.progress = 0.5
        shouldAnimate = true
    }
    
    private func setVisibleView(shouldProgressVisible: Bool) {
        vwRetryContainer.isHidden = shouldProgressVisible
        vwProgressContainer.isHidden = !shouldProgressVisible
    }
}
