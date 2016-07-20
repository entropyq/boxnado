//
//  GLSize.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/16/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

public struct GLSize {
    public var width: GLsizei
    public var height: GLsizei

    public init() {
        width = 0
        height = 0
    }

    public init(width: CGFloat, height: CGFloat) {
        self.width = GLsizei(width)
        self.height = GLsizei(height)
    }

    public init(size: CGSize) {
        self.width = GLsizei(size.width)
        self.height = GLsizei(size.height)
    }

    public init(size: CGSize, scaleFactor: CGFloat) {
        self.width = GLsizei(size.width * scaleFactor)
        self.height = GLsizei(size.height * scaleFactor)
    }

    public init(width: GLsizei, height: GLsizei) {
        self.width = width
        self.height = height
    }
}
