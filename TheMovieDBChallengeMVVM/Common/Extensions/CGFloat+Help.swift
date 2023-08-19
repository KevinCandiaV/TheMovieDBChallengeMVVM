//
//  CGFloat+Help.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

extension CGFloat {
    
    public static let automatic: CGFloat = CGFloat.greatestFiniteMagnitude - 1 // Subtracting one to reduce posibility of dupliaction
    public static let none: CGFloat = -automatic
    
    public var numberValue:NSNumber {
        return NSNumber(value: doubleValue)
    }
    
    public var doubleValue:Double {
        return Double(self)
    }
    
}

extension Float {

    public var cgFloatValue:CGFloat {
        return CGFloat(self)
    }

}

extension Double {

    public var cgFloatValue:CGFloat {
        return CGFloat(self)
    }

}
