//
//  ActivityOverlay.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

extension CGFloat {
    
    static let tinySpacing: CGFloat   = 4
    static let smallSpacing: CGFloat  = tinySpacing*2
    static let mediumSpacing: CGFloat = tinySpacing*3
    static let largeSpacing: CGFloat  = tinySpacing*4
    
}

open class ActivityOverlay: UIViewController, AlertPresentable {
    
    public dynamic static var defaultMessage: NSAttributedString = NSAttributedString(string: "", attributes: [.font : UIFont.boldSystemFont(ofSize: 24)])
    
    // MARK: - Properties - UI Elements
    public var stackView: UIStackView!
    public var activityView: ActivityView!
    public var messageLabel: UILabel!
    
    // MARK: - Properties
    public var message: NSAttributedString?
    public dynamic var spinnerColor: UIColor = UIColor(hexString: "#EC0000") {
        didSet {
            updateView()
        }
    }
    
    private static var presentedActivityOverlay: ActivityOverlay?
    private static var presentedAlert: Alert?
    public weak var alert: Alert!

    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        updateView()
    }
    
    private func initializeView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = .largeSpacing
        view.addSubview(stackView)
        
        stackView.addConstraints(toSuperviewVerticalCenterWithOffset: 0)
        stackView.addConstraints(toSuperviewWithMargins: UIEdgeInsets(top: .none, left: .mediumSpacing, bottom: .none, right: .mediumSpacing),
                                 relation: .equal,
                                 priority: .required)
        stackView.addConstraints(toSuperviewWithMargins: UIEdgeInsets(top: .mediumSpacing, left: .none, bottom: .mediumSpacing, right: .none),
                                 relation: .greaterThanOrEqual,
                                 priority: .required)
        
        activityView = ActivityView()
        activityView.size = .large
        activityView.isAnimating = true
        stackView.addArrangedSubview(activityView)
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Arial", size: 16)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.addArrangedSubview(messageLabel)
    }
    
    private func updateView() {
        messageLabel.attributedText = message
        messageLabel.isHidden = (message == nil)
        
        activityView.spinnerColor = spinnerColor
    }
    
    // MARK: - Public
    public class func show(message: NSAttributedString? = ActivityOverlay.defaultMessage, in view: UIView? = nil) {
        guard presentedAlert == nil else {
            print("Warning: JSActivityOverlay already presented")
            return
        }
        guard presentedActivityOverlay == nil else {
            print("Warning: JSActivityOverlay already presented")
            return
        }
        
        let activityOverlay = ActivityOverlay()
        activityOverlay.message = message
        
        if let view = view {
            activityOverlay.view.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            view.fillWithSubview(activityOverlay.view)
            presentedActivityOverlay = activityOverlay
        } else {
            let alert = Alert(style: .freeform, overlay: .light, animation: .zoom)
            alert.dismissOnTapOverlay = false
            alert.shadowColor = .clear
            alert.rootViewController = activityOverlay
            alert.show()
            presentedAlert = alert
        }
    }
    
    public class func dismiss() {
        if let presentedAlert = presentedAlert {
            presentedAlert.dismiss()
        }
        if let presentedActivityOverlay = presentedActivityOverlay {
            presentedActivityOverlay.view.removeFromSuperview()
        }
        self.presentedAlert = nil
        self.presentedActivityOverlay = nil
    }
    
}
