//
//  Boxnado.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/10/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

class Boxnado: RenderObject {
    private var mainProgram: GLuint = 0
    private var vertexBuffer: GLuint = 0
    private var boxes: [Box] = []
    private var boxIndex: Int = 0
    private var timeBetweenBoxes: NSTimeInterval = 0
    private var boxReleaseInterval: NSTimeInterval = 0.1 // one over number of boxes per second.


    var visible: Bool = true
    var objectMatrix = ObjectMatrix()

    var multiColorEnabled = false
    var randomnessRange: UInt32 = 0 // higher is more random

    var rotationVelocity: Float = 4.0

    var maxNumberOfBoxes: Int = 1000 {
        didSet {
            updateBoxCount()
        }
    }

    deinit {
        glDeleteBuffers(1, &vertexBuffer)
    }

    init(program: GLuint) {
        mainProgram = program
        
        // Create VBO for a cube.
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(sizeof(GLfloat) * CubeVertexData.count), &CubeVertexData, GLenum(GL_STATIC_DRAW))

        updateBoxCount()
    }

    // MARK:- RenderObject

    func update(timeDelta: NSTimeInterval, superModelViewProjectionMatrix: GLKMatrix4 = GLKMatrix4Identity) {
        if boxes.count > 0 {
            timeBetweenBoxes += timeDelta

            if timeBetweenBoxes > boxReleaseInterval {
                timeBetweenBoxes = 0

                boxIndex += 1
                if boxIndex >= boxes.count {
                    boxIndex = 0
                }

                // Start a new box
                let box = boxes[boxIndex]

                if multiColorEnabled {
                    switch boxIndex % 3 {
                    case 0:
                        box.color = GLKVector4Make(1, 0.5, 0.5, 1)
                    case 1:
                        box.color = GLKVector4Make(0.5, 1, 0.5, 1)
                    case 2:
                        box.color = GLKVector4Make(0.5, 0.5, 1, 1)
                    default:
                        print("won't happen")
                    }
                } else {
                    box.color = GLKVector4Make(0.5, 0.5, 1, 1)
                }

                box.randomMultiplier = Float(arc4random_uniform(randomnessRange+1) + 1) / Float(randomnessRange+1)

                box.start()
            }

            for box in boxes {
                box.rotationVelocity = rotationVelocity
                box.update(timeDelta, superModelViewProjectionMatrix: GLKMatrix4Multiply(Camera.sharedInstance.matrix, objectMatrix.modelMatrix))
            }
        }
    }

    func render() {
        if !visible {
            return
        }

        glUseProgram(mainProgram)

        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)

        glEnableVertexAttribArray(GLuint(SimpleShader.AttributeEnum.Position.rawValue))
        glVertexAttribPointer(GLuint(SimpleShader.AttributeEnum.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(0))
        glEnableVertexAttribArray(GLuint(SimpleShader.AttributeEnum.Normal.rawValue))
        glVertexAttribPointer(GLuint(SimpleShader.AttributeEnum.Normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))

        for box in boxes {
            box.render()
        }
    }

    // MARK:- Private

    private func updateBoxCount() {
        if maxNumberOfBoxes > boxes.count {
            for _ in boxes.count...maxNumberOfBoxes {
                boxes.insert(Box(), atIndex: boxIndex)
            }
        } else if maxNumberOfBoxes < boxes.count {
            let numberToRemove = boxes.count - maxNumberOfBoxes
            boxes.removeRange(boxes.endIndex-numberToRemove..<boxes.endIndex)
            for box in boxes {
                box.stop()
            }
        }
    }
}