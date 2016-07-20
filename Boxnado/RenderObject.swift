//
//  RenderObject.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/10/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import GLKit

protocol RenderObject {
    var visible: Bool {get set}
    var objectMatrix: ObjectMatrix {get}

    func update(timeDelta: NSTimeInterval, superModelViewProjectionMatrix: GLKMatrix4)
    func render()
}
