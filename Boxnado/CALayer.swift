//
//  CALayer.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/13/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import UIKit

extension CALayer {
    func applyCornerRadius(radius: CGFloat) {
        self.cornerRadius = radius
    }

    func applyBorder(color: UIColor, width: CGFloat) {
        self.borderColor = color.CGColor
        self.borderWidth = width
    }

    func applyDropShadowColor(color: UIColor, radius: CGFloat, offset: CGSize) {
        self.shadowColor = color.CGColor
        self.shadowOffset = offset
        self.shadowOpacity = 0.4
        self.shadowRadius = radius
    }
}
