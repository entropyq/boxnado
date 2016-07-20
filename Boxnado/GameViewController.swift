//
//  GameViewController.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/10/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit
import OpenGLES

func BUFFER_OFFSET(i: Int) -> UnsafePointer<Void> {
    let p: UnsafePointer<Void> = nil
    return p.advancedBy(i)
}

class GameViewController: GLKViewController {
    var context: EAGLContext? = nil
    var renderObjects: [RenderObject] = []
    var boxnado: Boxnado?

    var toonEnabled: GLint = 0

    deinit {
        self.tearDownGL()

        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredFramesPerSecond = 60

        self.context = EAGLContext(API: .OpenGLES2)

        if !(self.context != nil) {
            print("Failed to create ES context")
        }

        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format24

        self.setupGL()

        boxnado = Boxnado(program: SimpleShader.sharedInstance.program)
        boxnado!.objectMatrix.translation = GLKVector3Make(0, -4, 0)
        renderObjects.append(boxnado!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil

            self.tearDownGL()

            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Camera.sharedInstance.screenSize = view.bounds.size
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        Camera.sharedInstance.screenSize = view.bounds.size
    }

    // MARK: - GLKView and GLKViewController delegate methods

    func update() {
        for renderObject in renderObjects {
            renderObject.update(self.timeSinceLastUpdate, superModelViewProjectionMatrix: GLKMatrix4Identity)
        }
    }

    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        //view.bindDrawable()

        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

        glUniform1i(SimpleShader.sharedInstance.uniforms[SimpleShader.UniformEnum.ToonColorFlag.rawValue], toonEnabled)

        for renderObject in renderObjects {
            renderObject.render()
        }
    }

    // MARK: - Private

    private func setupGL() {
        EAGLContext.setCurrentContext(self.context)

        SimpleShader.sharedInstance.program

        // Set clear color.
        glClearColor(0.65, 0.65, 0.65, 1.0)

        glEnable(GLenum(GL_DEPTH_TEST))
    }

    private func tearDownGL() {
        EAGLContext.setCurrentContext(self.context)
        
        SimpleShader.sharedInstance.deleteProgram()
    }
}
