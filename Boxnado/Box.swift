//
//  Box.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/10/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

class Box: RenderObject {
    var visible: Bool = false
    var playing: Bool = false
    var objectMatrix = ObjectMatrix()
    var modelViewProjectionMatrix = GLKMatrix4Identity
    var normalMatrix = GLKMatrix3Identity

    var color = GLKVector4Make(1, 0, 0, 1)
    var heightIncreaseVelocity: Float = 0.4
    var radiusIncreaseVelocity: Float = 0.3
    var rotationVelocity: Float = 4

    var randomMultiplier: Float = 1

    private var height: Float = 0
    private var radius: Float = 0
    private var radians: Float = 0

    func reset() {
        height = 0
        radius = 0
        radians = 0
    }

    func start() {
        visible = true
        playing = true
        reset()
    }

    func stop() {
        visible = false
        playing = false
        reset()
    }

    // MARK:- RenderObject
    
    func update(timeDelta: NSTimeInterval, superModelViewProjectionMatrix: GLKMatrix4) {
        if !playing {
            return
        }

        let timeDeltaAsFloat = Float(timeDelta)
        radians += timeDeltaAsFloat * rotationVelocity * 0.5
        radius += timeDeltaAsFloat * radiusIncreaseVelocity * randomMultiplier
        height += timeDeltaAsFloat * heightIncreaseVelocity

        objectMatrix.translation = GLKVector3Make(radius, height, 0)
        objectMatrix.centerOfRotation = GLKVector3Make(-radius, height, 0)
        objectMatrix.rotation = GLKVector3Make(objectMatrix.rotation.x, radians, objectMatrix.rotation.z)

        modelViewProjectionMatrix = GLKMatrix4Multiply(superModelViewProjectionMatrix, objectMatrix.modelMatrix)
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewProjectionMatrix), nil)
    }

    func render() {
        if !visible {
            return
        }

        withUnsafePointer(&color, {
            glUniform4fv(SimpleShader.sharedInstance.uniforms[SimpleShader.UniformEnum.ColorVector.rawValue], 1, UnsafePointer($0))
        })

        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(SimpleShader.sharedInstance.uniforms[SimpleShader.UniformEnum.ModelViewProjectionMatrix.rawValue], 1, 0, UnsafePointer($0))
        })

        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(SimpleShader.sharedInstance.uniforms[SimpleShader.UniformEnum.NormalMatrix.rawValue], 1, 0, UnsafePointer($0))
        })

        glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
    }
}
