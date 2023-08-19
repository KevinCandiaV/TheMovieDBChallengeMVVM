//
//  ActivityView.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation
import UIKit

@IBDesignable
open class ActivityView: UIView {
    
    public enum Size {
        case small, large
        
        var image: UIImage? {
            let bundle = Bundle.init(for: ActivityView.self)
            switch self {
            case .small:
                return UIImage(named: "loader-small", in: bundle, compatibleWith: nil)
            case .large:
                return UIImage(named: "loader-large", in: bundle, compatibleWith: nil)
            }
        }
    }
    
    // MARK: - Properties - Configurable
    dynamic open var size: Size = .small {
        didSet { updateView() }
    }
    
    @IBInspectable
    dynamic open var animationDuration: CFTimeInterval = 0.6 {
        didSet { updateAnimation() }
    }
    
    @IBInspectable
    dynamic open var hidesWhenStopped: Bool = true {
        didSet { updateAnimation() }
    }
    
    @IBInspectable
    dynamic open var spinnerColor: UIColor = .gray {
        didSet { updateView() }
    }
    
    private var _customSpinnerImage: UIImage?
    dynamic open var spinnerImage: UIImage {
        get {
            if let customSpinnerImage = _customSpinnerImage {
                return customSpinnerImage
            }
            return size.image!
        }
        set { _customSpinnerImage = newValue }
    }
    
    // MARK: - Properties
    public var imageView: UIImageView!
    
    @IBInspectable
    open var isAnimating: Bool = true {
        didSet { updateAnimation() }
    }
    
    // MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    // MARK: - Rendering
    
    open override var intrinsicContentSize: CGSize {
        return spinnerImage.size
    }
    
    // MARK: - Private Methods
    private func initializeView() {
        clipsToBounds = true
        backgroundColor = .clear
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintAdjustmentMode = .normal
        addSubview(imageView)
        
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                     imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                                     imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
        updateView()
    }
    
    // MARK: - Open methods
    open func updateView() {
        imageView.image = spinnerImage
        imageView.apply(tintColor: spinnerColor)
        updateAnimation()
    }
    
    open func updateAnimation() {
        self.isHidden = !isAnimating && hidesWhenStopped
        if isAnimating {
            imageView.rotate(pi: Double.pi * 2.0, for: animationDuration)
        } else {
            imageView.removeRotate()
        }
    }
    
}
