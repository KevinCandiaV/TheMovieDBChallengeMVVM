//
//  UIView+Animations.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

public extension UIView {
    
    fileprivate enum AnimationKey {
        static let shake = "ShakeAnimation"
        static let rotate = "RotationAnimation"
        static let fade = CATransitionType.fade.rawValue
    }
    
    func shake() {
        removeShake()//  TheMovieDBChallengeMVVM
        let vals: [Double] = [-2, 2, -2, 2, 0]
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = vals
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = vals.map { (degrees: Double) in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 0.3
        layer.add(shakeGroup, forKey: AnimationKey.shake)
    }
    
    func removeShake() {
        layer.removeAnimation(forKey: AnimationKey.shake)
    }
    
    func fadeTransition(for duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func rotate(pi:Double, for duration: CFTimeInterval) {
        removeRotate()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = pi
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(rotationAnimation, forKey: AnimationKey.rotate)
    }
    
    func removeRotate() {
        layer.removeAnimation(forKey: AnimationKey.rotate)
    }
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}
