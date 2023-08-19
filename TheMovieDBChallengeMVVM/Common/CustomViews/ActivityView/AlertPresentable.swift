//
//  AlertPresentable.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation
import UIKit

public protocol AlertPresentable: class {
    var alert: Alert! { get set }
}

open class AlertContainerViewController: UIViewController {
    
    static let maxWidth: CGFloat = 400
    
    weak var alert: Alert!
    
    var overlayView: UIView!
    var blurView: UIVisualEffectView!
    var scrollView: UIScrollView!
    var scrollInnerView: UIView!
    var innerView: UIView!
    var innerInnerView: UIView!
    
    var margin: CGFloat {
        if alert.margin != .automatic {
            return alert.margin
        } else {
            switch alert.style {
            case .top, .bottom: return .smallSpacing
            case .center: return .largeSpacing*2
            case .full, .freeform: return .largeSpacing
            case .navbar, .ticker: return 0
            }
        }
    }
    
    var springDamping: CGFloat {
        if alert.springDamping != .automatic {
            return alert.springDamping
        } else {
            switch alert.style {
            case .top, .bottom: return 0.5
            case .center: return 0.5
            case .full, .freeform: return 0.6
            case .navbar, .ticker: return 1.0
            }
        }
    }
    
    var animationTime: TimeInterval {
        if alert.animationTime != CGFloat.automatic.doubleValue {
            return alert.animationTime
        } else {
            switch alert.style {
            case .top, .bottom: return 0.5
            case .center: return 0.5
            case .full, .freeform: return 0.5
            case .navbar, .ticker: return 0.5
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.clear
        
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.clear
        self.view.fillWithSubview(overlayView)
        
        blurView = UIVisualEffectView()
        blurView.backgroundColor = UIColor.clear
        blurView.isUserInteractionEnabled = false
        overlayView.fillWithSubview(blurView)
        
        let vibrancyView = UIVisualEffectView()
        vibrancyView.effect = UIVibrancyEffect()
        vibrancyView.backgroundColor = UIColor.clear
        blurView.contentView.fillWithSubview(vibrancyView)
        
        scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        scrollView.addConstraints(toSuperviewWithMargin: 0)
        
        scrollInnerView = UIView()
        scrollInnerView.backgroundColor = UIColor.clear
        scrollView.addSubview(scrollInnerView)
        scrollInnerView.addConstraints(toSuperviewWithMargin: 0)
        scrollInnerView.addConstraints(height: scrollView, relation: .greaterThanOrEqual)
        scrollInnerView.addConstraints(height: scrollView, priority: 200)
        scrollInnerView.addConstraints(width: scrollView)
        
        let overlayTapView = UIView()
        overlayTapView.backgroundColor = UIColor.clear
        scrollInnerView.fillWithSubview(overlayTapView)
        
        let view = scrollInnerView!
        let safeInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            switch alert.style {
            case .navbar, .ticker:
                safeInsets = .zero
            default:
                safeInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
            }
        } else {
            safeInsets = .zero
        }
        
        innerView = UIView()
        innerView.backgroundColor = UIColor.clear
        view.addSubview(innerView)
        innerView.addConstraints(
            toSuperviewWithMargins: .init(top: margin+safeInsets.top, left: margin+safeInsets.left, bottom: margin+safeInsets.bottom, right: margin+safeInsets.right),
            relation: .greaterThanOrEqual
        )
        innerView.addConstraints(toSuperviewHorizontalCenterWithOffset: 0)
        
        if alert.style != .freeform {
            innerView.addConstraints(width: AlertContainerViewController.maxWidth, relation: .lessThanOrEqual)
            innerView.addConstraints(width: AlertContainerViewController.maxWidth, priority: 900)
        }
        
        switch alert.style {
        case .center, .freeform:
            innerView.addConstraints(toSuperviewVerticalCenterWithOffset: 0, priority: 999)
        case .top:
            innerView.addConstraints(toSuperviewWithMargins: .init(top: margin+safeInsets.top, left: .none, bottom: .none, right: .none))
        case .ticker:
            innerView.addConstraints(toSuperviewWithMargins: .init(top: 0, left: .none, bottom: .none, right: .none))
            if #available(iOS 11.0, *) { // Ticker in iPhone x is full navbar
                let safeInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
                if safeInsets.top > 0 {
                    innerView.addConstraints(height: 44+safeInsets.top)
                } else {
                    innerView.addConstraints(height: 20)
                }
            } else {
                innerView.addConstraints(height: 20)
            }
        case .navbar:
            innerView.addConstraints(toSuperviewWithMargins: .init(top: 0, left: .none, bottom: .none, right: .none))
            if #available(iOS 11.0, *) {
                let safeInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
                if safeInsets.top > 0 {
                    innerView.addConstraints(height: 44+safeInsets.top)
                } else {
                    innerView.addConstraints(height: 44+20)
                }
            } else {
                innerView.addConstraints(height: 44+20)
            }
        case .bottom:
            innerView.addConstraints(toSuperviewWithMargins: .init(top: .none, left: .none, bottom: margin+safeInsets.bottom, right: .none))
        case .full:
            innerView.addConstraints(toSuperviewWithMargins: .init(top: margin+safeInsets.top, left: .none, bottom: margin+safeInsets.bottom, right: .none))
        }
        
        innerInnerView = UIView()
        innerView.fillWithSubview(innerInnerView)
        if let rootViewController = alert.rootViewController as? AlertPresentable {
            rootViewController.alert = alert
        }
        insertChild(viewController: alert.rootViewController, inView: innerInnerView)
        
        switch alert.style {
        case .top, .bottom, .center, .full, .freeform:
            innerInnerView.layer.masksToBounds = true
            innerInnerView.layer.cornerRadius = alert.cornerRadius
            innerView.layer.shadowRadius  = alert.shadowRadius
            innerView.layer.shadowColor   = alert.shadowColor.cgColor
            innerView.layer.shadowOffset  = alert.shadowOffset
            innerView.layer.shadowOpacity = 1.0
        case .navbar, .ticker:
            break
        }
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Register for Notifications
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) -> Void in
            self.keyboardShownChanged(show: true,  userInfo: (notification as NSNotification).userInfo)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) -> Void in
            self.keyboardShownChanged(show: false, userInfo: (notification as NSNotification).userInfo)
        }
    }
    
    func keyboardShownChanged(show: Bool, userInfo: [AnyHashable: Any]?) {
        let keyboardHeight       = (show ? ((userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size.height) : 0)
        let animationDuration    = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        var options = UIView.AnimationOptions()
        if let animationCurveRaw = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            options = UIView.AnimationOptions(rawValue: UInt(animationCurveRaw << 16))
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight/2), animated: false)
        }, completion: nil)
    }
    
    open func setMoveToHidden() {
        switch alert.animation {
        case .top:
            let transformY = -(innerView.frame.origin.y+innerView.frame.size.height)
            innerView.transform = CGAffineTransform(translationX: 0, y: transformY)
        case .bottom:
            let transformY = view.frame.size.height-innerView.frame.origin.y
            innerView.transform = CGAffineTransform(translationX: 0, y: transformY)
        case .zoom:
            innerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        case .none:
            break
        }
    }
    
    open func setStateToHidden() {
        switch alert.animation {
        case .top:
            break
        case .bottom:
            break
        case .zoom:
            innerView.alpha = 0
        case .none:
            break
        }
        view.backgroundColor = UIColor.clear
    }
    
    open func setBlurToHidden() {
        blurView.effect = nil
    }
    
    open func setMoveToNormal() {
        innerView.transform = CGAffineTransform.identity
    }
    
    open func setStateToNormal() {
        innerView.alpha = 1
        switch alert.overlay {
        case .blur:
            overlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        case .dark:
            overlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        case .light:
            overlayView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        case .none:
            overlayView.backgroundColor = .clear
        }
    }
    
    open func setBlurToNormal() {
        switch alert.overlay {
        case .blur:
            blurView.effect = UIBlurEffect(style: .dark)
        case .dark, .light, .none:
            blurView.effect = nil
        }
    }
    
    open func prepareEntrance(window: UIWindow) {
        switch alert.overlay {
        case .blur, .dark, .light:
            window.isUserInteractionEnabled = true
        case .none:
            window.isUserInteractionEnabled = false
        }
        view.layoutIfNeeded()
        setMoveToHidden()
        setStateToHidden()
        setBlurToHidden()
    }
    
    open func performEntrance(animated: Bool = true, completion: (() -> Void)?) {
        UIView.animate(
            withDuration: (animated ? animationTime: 0.0),
            delay: 0,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: 0.0,
            options: .curveLinear,
            animations: {
                self.setMoveToNormal()
        },
            completion: { finished in
                completion?()
        }
        )
        UIView.animate(
            withDuration: (animated ? (animationTime/2): 0.0),
            delay: 0,
            options: .curveLinear,
            animations: {
                self.setStateToNormal()
        },
            completion: nil
        )
        UIView.animate(
            withDuration: (animated ? (animationTime/2)*4: 0.001*4),
            delay: 0,
            options: .curveLinear,
            animations: {
                self.setBlurToNormal()
        },
            completion: nil
        )
        blurView.pauseAnimation(delay: (animated ? (animationTime/2): 0.001))
    }
    
    open func performExit(animated: Bool = true, completion: (() -> Void)?) {
        blurView.resumeAnimation()
        UIView.animate(
            withDuration: (animated ? (animationTime/2): 0.0),
            delay: 0,
            options: [.curveLinear, .beginFromCurrentState],
            animations: {
                self.setMoveToHidden()
                self.setStateToHidden()
                self.setBlurToHidden()
        },
            completion: { finished in
                completion?()
        }
        )
    }
    
}

extension UIView {
    
    public func pauseAnimation(delay: Double) {
        let time = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, time, 0, 0, 0, { timer in
            let layer = self.layer
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        })
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    }
    
    public func resumeAnimation() {
        let pausedTime  = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
}
