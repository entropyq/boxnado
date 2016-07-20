//
//  ControlView.swift
//  Boxnado
//
//  Created by Matt Loflin on 7/13/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

import UIKit

protocol ControlViewProtocol: class {
    func onBoxCountChanged(maxBoxCount: Int)
    func onSpeedChanged(speed: Float)
    func onRandomnessChanges(randomness: Int)
    func onMultiColorChanged(enableMultiColor: Bool)
    func onToonChanged(enableToon: Bool)
}

class ControlView: UIView {
    @IBOutlet weak var showHideButton: UIButton!
    @IBOutlet weak var buttonGraphicView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var boxCountLabel: UILabel!
    @IBOutlet weak var boxCountSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var randomnessLabel: UILabel!
    @IBOutlet weak var randomnessSlider: UISlider!
    @IBOutlet weak var multiColorToggleButton: UIButton!
    @IBOutlet weak var toonToggleButton: UIButton!

    private var controlsVisible = true

    weak var delegate: ControlViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()

        buttonGraphicView.layer.applyCornerRadius(5)

        for view in [multiColorToggleButton, toonToggleButton] {
            view.layer.applyCornerRadius(5)
            view.layer.applyBorder(UIColor.whiteColor(), width: 1)
        }

        hide(false)
        onBoxCountSliderValueChange(boxCountSlider)
        onSpeedSliderValueChange(speedSlider)
    }

    func hide(animate: Bool = true) {
        if controlsVisible {
            controlsVisible = false
            updateVisibility(backgroundView.frame.size.height, animate: animate)
        }
    }

    func toggleVisibility(animate: Bool = true) {
        controlsVisible = !controlsVisible
        let yOffset = controlsVisible ? 0 : backgroundView.frame.size.height
        updateVisibility(yOffset, animate: animate)
    }

    @IBAction func onShowHideButtonTouch(sender: AnyObject) {
        toggleVisibility()
    }

    @IBAction func onBoxCountSliderValueChange(slider: UISlider) {
        let maxBoxCount = Int(slider.value)
        boxCountLabel.text = "Max Boxes: \(maxBoxCount)"
        delegate?.onBoxCountChanged(maxBoxCount)
    }

    @IBAction func onSpeedSliderValueChange(slider: UISlider) {
        let speed = round(slider.value * 2) / 2 // Snap to closest 0.5
        slider.setValue(speed, animated: false)
        speedLabel.text = "Speed: \(speed)"
        delegate?.onSpeedChanged(speed)
    }

    @IBAction func onRandomnessSlierValueChange(slider: UISlider) {
        let randomness = Int(slider.value)
        randomnessLabel.text = "Randomness: \(randomness)"
        delegate?.onRandomnessChanges(randomness)
    }

    @IBAction func onMultiColorToggleButtonTouch(sender: AnyObject) {
        multiColorToggleButton.selected = !multiColorToggleButton.selected
        toggleApperanceOfButton(multiColorToggleButton)
        delegate?.onMultiColorChanged(multiColorToggleButton.selected)
    }

    @IBAction func onToonToggleButtonTouch(sender: AnyObject) {
        toonToggleButton.selected = !toonToggleButton.selected
        toggleApperanceOfButton(toonToggleButton)
        delegate?.onToonChanged(toonToggleButton.selected)
    }

    // MARK: - private

    private func toggleApperanceOfButton(button: UIButton) {
        button.backgroundColor = button.selected ? UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) : UIColor.clearColor()
    }

    private func updateVisibility(offset: CGFloat, animate: Bool = true) {
        if animate {
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { [weak self] () -> Void in
                self?.transform = CGAffineTransformMakeTranslation(0, offset)
                }, completion: nil)
        } else {
            transform = CGAffineTransformMakeTranslation(0, offset)
        }
    }
}
