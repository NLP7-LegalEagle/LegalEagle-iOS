//
//  UIView+.swift
//  LegalEagle
//
//  Created by BoMin Lee on 11/20/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
