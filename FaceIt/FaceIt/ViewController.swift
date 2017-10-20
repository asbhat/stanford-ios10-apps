//
//  ViewController.swift
//  FaceIt
//
//  Created by Aditya Bhat on 7/8/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // initialized as an Optional, so didSet only gets called once (after the outlet is hooked up)
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))  // defaults to 1 tap
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            // tapRecognizer.require(toFail: doubleTapRecognizer)  // BLARG makes the eyes 'lag'
            let tapPanRecognizer = UITapThenPanGestureRecognizer(target: faceView, action: #selector(FaceView.zoom(byReactingTo:)))
            faceView.addGestureRecognizer(pinchRecognizer)
            faceView.addGestureRecognizer(tapRecognizer)
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            faceView.addGestureRecognizer(tapPanRecognizer)
            updateUI()
        }
    }

    var expression = FacialExpression(eyes: .open, mouth: .smile) {
        didSet {
            updateUI()
        }
    }

    @objc func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }

    @objc func increaseHappiness() {
        expression = expression.happier
    }

    @objc func decreaseHappiness() {
        expression = expression.sadder
    }

    // optional chaining in case this is called before faceView is initialized
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }

    private let mouthCurvatures: [FacialExpression.Mouth: Double] = [
        .frown: -1.0,
        .grimmace: -0.5,
        .neutral: 0.0,
        .grin: 0.5,
        .smile: 1.0
    ]
}
