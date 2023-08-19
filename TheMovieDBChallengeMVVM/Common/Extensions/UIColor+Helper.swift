//
//  UIColor+Helper.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import UIKit

extension UIColor {
    
    // MARK: - Private
    fileprivate class func colorComponent(from str:String, start:Int, length:Int) -> CGFloat {
        let range = str.index(str.startIndex, offsetBy: start)..<str.index(str.startIndex, offsetBy: start+length)
        let substring = String(str[range])
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent:CUnsignedInt = 0
        Scanner(string: fullHex).scanHexInt32(&hexComponent)
        return CGFloat(hexComponent)/255.0
    }
    
    // MARK: - Properties
    public var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return String(
            format: "#%02lX%02lX%02lX",
            Int(red * multiplier),
            Int(green * multiplier),
            Int(blue * multiplier)
        )
    }
    
    // MARK: - Lifecycle
    public convenience init(hexString:String, alpha:CGFloat = -1) {
        let colorString = hexString.replacingOccurrences(of: "#", with: "")
        var alphaColor, red, blue, green:CGFloat
        
        switch(colorString.count) {
        case 3: // #RGB
            alphaColor = 1.0
            red   = UIColor.colorComponent(from: colorString, start: 0, length: 1)
            green = UIColor.colorComponent(from: colorString, start: 1, length: 1)
            blue  = UIColor.colorComponent(from: colorString, start: 2, length: 1)
            break;
        case 4: // #ARGB
            alphaColor = UIColor.colorComponent(from: colorString, start: 0, length: 1)
            red   = UIColor.colorComponent(from: colorString, start: 1, length: 1)
            green = UIColor.colorComponent(from: colorString, start: 2, length: 1)
            blue  = UIColor.colorComponent(from: colorString, start: 3, length: 1)
            break;
        case 6: // #RRGGBB
            alphaColor = 1.0
            red   = UIColor.colorComponent(from: colorString, start: 0, length: 2)
            green = UIColor.colorComponent(from: colorString, start: 2, length: 2)
            blue  = UIColor.colorComponent(from: colorString, start: 4, length: 2)
            break;
        case 8: // #AARRGGBB
            alphaColor = UIColor.colorComponent(from: colorString, start: 0, length: 2)
            red   = UIColor.colorComponent(from: colorString, start: 2, length: 2)
            green = UIColor.colorComponent(from: colorString, start: 4, length: 2)
            blue  = UIColor.colorComponent(from: colorString, start: 6, length: 2)
            break;
        default:
            alphaColor = 1.0
            red   = 0
            green = 0
            blue  = 0
            break;
        }
        if (alpha != -1) {
            alphaColor = alpha
        }
        self.init(red:red, green:green, blue:blue, alpha:alphaColor)
    }
    
    public convenience init(redIntColor:Int, greenIntColor:Int, blueIntColor:Int, alphaIntColor:CGFloat) {
        self.init(red: CGFloat(redIntColor)/255.0, green: CGFloat(greenIntColor)/255.0, blue: CGFloat(blueIntColor)/255.0, alpha: alphaIntColor)
    }
    
    // MARK: - Public
    public func blended(withFraction fraction: CGFloat, ofColor color: UIColor) -> UIColor {
        var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
        var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
                       green: g1 * (1 - fraction) + g2 * fraction,
                       blue: b1 * (1 - fraction) + b2 * fraction,
                       alpha: a1 * (1 - fraction) + a2 * fraction)
    }
    
    public func with(alpha newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 1.0
        var saturation: CGFloat = 1.0
        var brightness: CGFloat = 1.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
}
