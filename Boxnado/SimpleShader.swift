//
//  SimpleShader.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/13/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

class SimpleShader {
    static let sharedInstance = SimpleShader()

    enum AttributeEnum: Int {
        case Position = 0
        case Normal
        case MaxCount
    }

    private(set) var attributes = [GLuint](count: AttributeEnum.MaxCount.rawValue, repeatedValue: 0)

    enum UniformEnum: Int {
        case ModelViewProjectionMatrix = 0
        case NormalMatrix
        case ColorVector
        case ToonColorFlag
        case MaxCount
    }

    private(set) var uniforms = [GLint](count: UniformEnum.MaxCount.rawValue, repeatedValue: 0)

    var program: GLuint {
        get {
            if programId == 0 {
                createProgram()
            }

            return programId
        }
    }

    private var programId: GLuint = 0

    private func createProgram() {
        if programId != 0 {
            return
        }

        programId = ShaderManager.loadShaders("Simple", fragmentFilename: "Simple", prelinkBlock: nil, postlinkBlock: { (program: GLuint) in
            // Get attribute locations.
            self.attributes[AttributeEnum.Position.rawValue] = GLuint(glGetAttribLocation(program, "a_position"))
            self.attributes[AttributeEnum.Normal.rawValue] = GLuint(glGetAttribLocation(program, "a_normal"))
            
            // Get uniform locations.
            self.uniforms[UniformEnum.ModelViewProjectionMatrix.rawValue] = glGetUniformLocation(program, "u_mvp_matrix")
            self.uniforms[UniformEnum.NormalMatrix.rawValue] = glGetUniformLocation(program, "u_normal_matrix")
            self.uniforms[UniformEnum.ColorVector.rawValue] = glGetUniformLocation(program, "u_color")
            self.uniforms[UniformEnum.ToonColorFlag.rawValue] = glGetUniformLocation(program, "u_toon_coloring")
        })
    }

    func deleteProgram() {
        if programId != 0 {
            glDeleteProgram(program)
            programId = 0
        }
    }
}