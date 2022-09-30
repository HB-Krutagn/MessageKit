//
//  HBProgressView.swift
//  qtconnect
//
//  Created by hb on 12/09/22.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

open class HBProgressView: UIView, MDCActivityIndicatorDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var stackVW: UIStackView!
    @IBOutlet weak var vwProgressContainer: UIView!
    @IBOutlet weak var activityIndicator: MDCActivityIndicator!
    @IBOutlet weak var vwRetryContainer: UIView!

    public lazy var btnCancel: UIButton = {
        let btn = UIButton()
        if let image = UIImage(named: "ic_cancel_white", in: Bundle.messageKitAssetBundle, compatibleWith: nil) {
            btn.setImage(image, for: .normal)
        }
        return btn
    }()
    
    public lazy var btnRetry: UIButton = {
        let btn = UIButton()
        if let image = UIImage(named: "retry", in: Bundle.messageKitAssetBundle, compatibleWith: nil) {
            btn.setImage(image, for: .normal)
        }
        return btn
    }()
    public var onCompletionOfProgress  : (() -> ())?
    
    // MARK: - Variables
    public var progress: Float = 0.0 {
        didSet {
            activityIndicator.setProgress(progress, animated: false)
            if progress >= 1.0 || progress <= 0.0 {
                btnCancel.isHidden = true
            } else {
                btnCancel.isHidden = false
            }
        }
    }
        
    public var indicatorMode: MDCActivityIndicatorMode = .determinate {
        didSet {
            activityIndicator.indicatorMode = indicatorMode
        }
    }
    
    public var indicatorRadius: CGFloat = 25 {
        didSet {
            activityIndicator.radius = indicatorRadius
        }
    }
    
    public var indicatorStrockWidth: CGFloat = 5.0 {
        didSet {
            activityIndicator.strokeWidth = indicatorStrockWidth
        }
    }

    public var indicatorColor: UIColor = .white {
        didSet {
            activityIndicator.cycleColors = [indicatorColor]
        }
    }

    public var indicatorTrackEnabled: Bool = true {
        didSet {
            activityIndicator.trackEnabled = indicatorTrackEnabled
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
        vwProgressContainer.addSubview(btnCancel)
        btnCancel.frame = activityIndicator.bounds
        btnCancel.centerInSuperview()
        vwProgressContainer.bringSubviewToFront(btnCancel)
        vwRetryContainer.addSubview(btnRetry)
        activityIndicator.delegate = self
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
    }

    // MARK: - Custom Methods
    open func setVisibleView(shouldProgressVisible: Bool) {
        vwRetryContainer.isHidden = shouldProgressVisible
        vwProgressContainer.isHidden = !shouldProgressVisible
    }
    
    public func activityIndicatorAnimationDidFinish(_ activityIndicator: MDCActivityIndicator) {
        onCompletionOfProgress?()
    }
}
