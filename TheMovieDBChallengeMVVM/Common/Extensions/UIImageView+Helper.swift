//
//  UIImageView+Helper.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

extension UIImageView {
    
    public func apply(tintColor color: UIColor) {
        if image != nil {
            image = image?.withRenderingMode(.alwaysTemplate)
            tintColor = color
        }
    }
    
}
