//
//  MainViewController.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/10/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ControlViewProtocol {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var controlView: ControlView!

    private var gameViewController: GameViewController?
    private let tapGestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameViewController = childViewControllers.last as? GameViewController
        controlView.delegate = self
        view.bringSubviewToFront(controlView)

        tapGestureRecognizer.addTarget(self, action: #selector(onBackgroundTap(_:)))
        containerView.addGestureRecognizer(tapGestureRecognizer)
    }

    func onBackgroundTap(recognizer: UITapGestureRecognizer) {
        controlView.hide()
    }

    // MARK:- ControlViewProtocol

    func onBoxCountChanged(maxBoxCount: Int) {
        if let gameViewController = gameViewController {
            gameViewController.boxnado?.maxNumberOfBoxes = maxBoxCount
        }
    }

    func onSpeedChanged(speed: Float) {
        if let gameViewController = gameViewController {
            gameViewController.boxnado?.rotationVelocity = speed
        }
    }

    func onRandomnessChanges(randomness: Int) {
        if let gameViewController = gameViewController {
            gameViewController.boxnado?.randomnessRange = UInt32(randomness)
        }
    }

    func onMultiColorChanged(enableMultiColor: Bool) {
        if let gameViewController = gameViewController {
            gameViewController.boxnado?.multiColorEnabled = enableMultiColor
        }
    }

    func onToonChanged(enableToon: Bool) {
        if let gameViewController = gameViewController {
            gameViewController.toonEnabled = enableToon ? 1 : 0
        }
    }
}
