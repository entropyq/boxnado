//
//  Camera.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/12/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

class Camera {
    static let sharedInstance = Camera()

    // The camera matrix.
    private(set) var matrix: GLKMatrix4!

    var screenSize = CGSizeMake(400, 400) {
        didSet {
            aspect = fabsf(Float(screenSize.width / screenSize.height))
            updateMatrix()
        }
    }

    var eyeVector = GLKVector3Make(0, 0, 20) {
        didSet {
            updateMatrix()
        }
    }

    var centerVector = GLKVector3Make(0, 0, 0) {
        didSet {
            updateMatrix()
        }
    }

    var upVector = GLKVector3Make(0, 1, 0) {
        didSet {
            updateMatrix()
        }
    }

    var fieldOfViewAngle: Float = 90 {
        didSet {
            updateMatrix()
        }
    }

    private(set) var projectionMatrix: GLKMatrix4!
    private var viewMatrix: GLKMatrix4!

    private var aspect: Float = 1
    private let near: Float = 0.1
    private let far: Float = 100.0

    private func updateMatrix() {
        projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fieldOfViewAngle), aspect, near, far)
        viewMatrix = GLKMatrix4MakeLookAt(eyeVector.x, eyeVector.y, eyeVector.z, centerVector.x, centerVector.y, centerVector.z, upVector.x, upVector.y, upVector.z)
        matrix = GLKMatrix4Multiply(projectionMatrix, viewMatrix)
    }
}
