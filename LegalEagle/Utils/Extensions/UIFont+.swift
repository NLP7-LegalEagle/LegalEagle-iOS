//
//  UIFont+.swift
//  LegalEagle
//
//  Created by BoMin Lee on 11/24/23.
//

import UIKit

extension UIFont {
    enum FontWeight: String {
        case bold
        case regular
        case semiBold
        
        var value: String {
            self.rawValue.capitalized
        }
    }
    
    static func pretendard(size:CGFloat, weight: FontWeight = .regular) -> UIFont {
        return UIFont(name: "Pretendard-\(weight.value)", size: size)!
    }
}

