//
//  ObjectMatrix.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/12/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

class ObjectMatrix {

    var translation = GLKVector3Make(0, 0, 0) {
        didSet {
            updateMatrix()
        }
    }

    var centerOfRotation = GLKVector3Make(0, 0, 0) {
        didSet {
            updateMatrix()
        }
    }

    var rotation = GLKVector3Make(0, 0, 0) {
        didSet {
            updateMatrix()
        }
    }

    var scale = GLKVector3Make(1, 1, 1) {
        didSet {
            updateMatrix()
        }
    }

    var modelMatrix = GLKMatrix4Identity

    private func updateMatrix() {
        let translationMatrix = GLKMatrix4MakeTranslation(translation.x, translation.y, translation.z)
        let centerOfRotationMatrix = GLKMatrix4MakeTranslation(centerOfRotation.x, centerOfRotation.y, centerOfRotation.z)
        let inverseCenterOfRotation = GLKVector3MultiplyScalar(centerOfRotation, -1)
        let inverseCenterOfRotationMatrix = GLKMatrix4MakeTranslation(inverseCenterOfRotation.x,
                                                                      inverseCenterOfRotation.y,
                                                                      inverseCenterOfRotation.z)
        let rotationMatrix = GLKMatrix4Multiply( GLKMatrix4Multiply(GLKMatrix4RotateX(GLKMatrix4Identity, rotation.x), GLKMatrix4RotateY(GLKMatrix4Identity, rotation.y)), GLKMatrix4RotateZ(GLKMatrix4Identity, rotation.z))
        let scaleMatrix = GLKMatrix4MakeScale(scale.x, scale.y, scale.z)

        modelMatrix = GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(GLKMatrix4Multiply(translationMatrix, centerOfRotationMatrix), rotationMatrix), inverseCenterOfRotationMatrix), scaleMatrix)
    }
}