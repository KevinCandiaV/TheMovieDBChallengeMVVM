//
//  Alert.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

public class Alert {
    
    public static var cornerRadius: CGFloat = .tinySpacing
    public static var shadowColor: UIColor  = UIColor.black.with(alpha: 0.6)
    public static var shadowRadius: CGFloat = .smallSpacing
    public static var shadowOffset: CGSize  = CGSize(width: 0, height: 2)
    
    public var cornerRadius: CGFloat = Alert.cornerRadius
    public var shadowColor: UIColor  = Alert.shadowColor
    public var shadowRadius: CGFloat = Alert.shadowRadius
    public var shadowOffset: CGSize  = Alert.shadowOffset
    
    public var alertWindow: UIWindow?
    public static var presentedAlerts: Set<Alert> = []
    
    public var margin: CGFloat = .automatic
    public var springDamping: CGFloat = .automatic
    public var animationTime: TimeInterval = CGFloat.automatic.doubleValue
    public var autoDismissTime: TimeInterval?
    
    public lazy var onShow = ObservableCall<Alert>()
    public lazy var onDismiss = ObservableCall<Alert>()
    public var dismissOnTapOverlay: Bool = true
    
    public enum Style {
        case full, top, center, bottom, navbar, ticker, freeform
    }
    public var style: Style
    
    public enum Overlay {
        case dark, light, blur, none
    }
    public var overlay: Overlay
    
    public enum Animation {
        case zoom, top, bottom, none
    }
    public var animation: Animation
    
    public var rootViewController: UIViewController!
    
    public init(style: Style = .center, overlay: Overlay = .dark, animation: Animation = .zoom) {
        self.style = style
        self.overlay = overlay
        self.animation = animation
    }
    
    private var autoDismissTimer: Timer?
    
    public func show(seconds: TimeInterval? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard rootViewController != nil else { print("Alert RootViewController not set"); return }
        guard alertWindow == nil else { return }
        Alert.presentedAlerts.insert(self)
        if let seconds = seconds { autoDismissTime = seconds }
        let window = UIApplication.shared.keyWindow!
        alertWindow = UIWindow(frame: window.frame)
        alertWindow!.backgroundColor = UIColor.clear
        alertWindow!.windowLevel = UIWindow.Level.alert
        let newWindowVC = AlertContainerViewController()
        newWindowVC.alert = self
        alertWindow!.rootViewController = newWindowVC
        alertWindow!.makeKeyAndVisible()
        newWindowVC.prepareEntrance(window: alertWindow!)
        newWindowVC.performEntrance(animated: animated) {
            self.onShow.notify(with: self)
            if let autoDismissTime = self.autoDismissTime {
                self.autoDismissTimer = Timer.scheduledTimer(withTimeInterval: autoDismissTime, repeats: false, block: { _ in
                    self.dismiss(animated: animated, completion: completion)
                })
            } else {
                completion?()
            }
        }
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let viewController = alertWindow?.rootViewController as? AlertContainerViewController else { return }
        autoDismissTimer?.invalidate()
        viewController.performExit(animated: animated, completion: {
            self.alertWindow?.resignFirstResponder()
            self.alertWindow = nil
            let window = UIApplication.shared.keyWindow!
            window.makeKeyAndVisible()
            Alert.presentedAlerts.remove(self)
            self.onDismiss.notify(with: self)
            completion?()
        })
    }
    
}

extension Alert: Hashable {
    
    public var hashValue: Int {
        return "\(style)-\(overlay)-\(animation)-\(rootViewController.hashValue)".hashValue
    }
    
    public static func ==(lhs: Alert, rhs: Alert) -> Bool{
        return lhs.hashValue == rhs.hashValue
    }
    
}
