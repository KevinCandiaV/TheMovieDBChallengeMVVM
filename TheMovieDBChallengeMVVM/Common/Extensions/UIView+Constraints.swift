//
//  Extension.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

public extension UIView {
    
    // MARK: General methods
    func addConstraints(toSuperviewWithVisualFormat format: String, views: [String: UIView] = [:]) {
        var bindings = ["view": self]
        bindings.merge(views, uniquingKeysWith: { view1, view2 in return view2 })
        NSLayoutConstraint.addConstraints(withVisualFormat: format, views: bindings)
    }
    
    // MARK: Size constraints
    func addConstraints(size: CGSize, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        addConstraints(width: size.width, relation: relation, priority: priority)
        addConstraints(height: size.height, relation: relation, priority: priority)
    }
    
    func addConstraints(width: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        guard width != .none && width != .automatic else { return }
        addConstraints(toSuperviewWithVisualFormat: "H:[view(\(relation.visualString)\(width)@\(priority.rawValue))]")
    }
    
    func addConstraints(height: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        guard height != .none && height != .automatic else { return }
        addConstraints(toSuperviewWithVisualFormat: "V:[view(\(relation.visualString)\(height)@\(priority.rawValue))]")
    }
    
    func addConstraints(size secondView: UIView, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        addConstraints(width: secondView, relation: relation, priority: priority)
        addConstraints(height: secondView, relation: relation, priority: priority)
    }
    
    func addConstraints(width secondView: UIView, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        let views: [String: UIView] = ["secondView": secondView]
        addConstraints(toSuperviewWithVisualFormat: "H:[view(\(relation.visualString)secondView@\(priority.rawValue))]", views: views)
    }
    
    func addConstraints(height secondView: UIView, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        let views: [String: UIView] = ["secondView": secondView]
        addConstraints(toSuperviewWithVisualFormat: "V:[view(\(relation.visualString)secondView@\(priority.rawValue))]", views: views)
    }
    
    // MARK: Centering constraints
    
    func addConstraints(toSuperviewHorizontalCenterWithOffset offset: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([constraint])
    }
    
    func addConstraints(toSuperviewVerticalCenterWithOffset offset: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: offset)
        NSLayoutConstraint.activate([constraint])
    }
    
    // MARK: Margin fill constraints
    
    func fillWithSubview(_ view: UIView, margin: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        addSubview(view)
        view.addConstraints(toSuperviewWithMargin: margin, relation: relation, priority: priority)
    }
    
    func addConstraints(toSuperviewWithMargin margin: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        addConstraints(toSuperviewWithMargins: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin), relation: relation, priority: priority)
    }
    
    func addConstraints(toSuperviewWithMargins margins: UIEdgeInsets, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
        if margins.top != .none && margins.top != .automatic {
            addConstraints(toSuperviewWithVisualFormat: "V:|-\(relation.visualString)\(margins.top)@\(priority.rawValue)-[view]")
        }
        if margins.bottom != .none && margins.bottom != .automatic {
            addConstraints(toSuperviewWithVisualFormat: "V:[view]-\(relation.visualString)\(margins.bottom)@\(priority.rawValue)-|")
        }
        if margins.left != .none && margins.left != .automatic {
            addConstraints(toSuperviewWithVisualFormat: "H:|-\(relation.visualString)\(margins.left)@\(priority.rawValue)-[view]")
        }
        if margins.right != .none && margins.right != .automatic {
            addConstraints(toSuperviewWithVisualFormat: "H:[view]-\(relation.visualString)\(margins.right)@\(priority.rawValue)-|")
        }
    }
    
}

public extension NSLayoutConstraint.Relation {
    
    var visualString: String {
        switch self {
        case .equal: return "=="
        case .lessThanOrEqual: return "<="
        case .greaterThanOrEqual: return ">="
        @unknown default:
            fatalError()
        }
    }
}

public extension NSLayoutConstraint {
    
    static func addConstraints(withVisualFormat format: String, views: [String: UIView] = [:]) {
        for view in views {
            view.value.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint = NSLayoutConstraint.constraints(
            withVisualFormat: format, options: [], metrics: nil, views: views
        )
        NSLayoutConstraint.activate(constraint)
    }
}

extension UILayoutPriority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }
    
}


public struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

public extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}

