//
//  String+Extensions.swift
//  TheMovieDBChallengeMVVM
//
//  Created by Kevin Candia Villagómez on 19/08/23.
//

import Foundation

public extension String {
    
    // MARK: - Properties
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars.compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    // MARK: - Methods
    func replaceParams(params: String...) -> String {
        var result = self
        var index = 0
        for param in params {
            let paramString = "{\(index)}"
            result = result.replacingOccurrences(of: paramString, with: param)
            index+=1
        }
        return result
    }
    
    func text(before text: String) -> String? {
        guard let range = self.range(of: text) else { return nil }
        return String(self[self.startIndex..<range.lowerBound])
    }
    
    func removeLines() -> String{
        return self.replacingOccurrences(of: "\n", with: " ")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func isPhotoExtension() -> Bool{
        let extensionFile = self.components(separatedBy: ".").last ?? ""
        let allowedExtension = ["jpeg","JPEG","png","PNG","JPG","jpg"]
        if allowedExtension.contains(extensionFile){
            return true
        }
        return false
    }

}
public extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter { $0.isWholeNumber } }
}

public extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}
