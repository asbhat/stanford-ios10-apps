//
//  GraphingViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 11/9/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class GraphingViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private var graphingModel = GraphingModel() {
        didSet {
            updateGraphingViewFunction()
        }
    }
    // var graphingModel: (equation: ((Double) -> Double)?, description: String?)

    @IBOutlet weak var graphingView: GraphingView! {
        didSet {
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphingView, action: #selector(graphingView.zoom(byReactingTo:)))
            let panRecognizer = UIPanGestureRecognizer(target: graphingView, action: #selector(graphingView.move(byReactingTo:)))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphingView, action: #selector(graphingView.shift(byReactingTo:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            let tapPanRecognizer = UITapThenPanGestureRecognizer(target: graphingView, action: #selector(graphingView.oneFingerZoom(byReactingTo:)))

            doubleTapRecognizer.delegate = self
            tapPanRecognizer.delegate = self

            graphingView.addGestureRecognizer(pinchRecognizer)
            graphingView.addGestureRecognizer(panRecognizer)
            graphingView.addGestureRecognizer(doubleTapRecognizer)
            graphingView.addGestureRecognizer(tapPanRecognizer)
            updateGraphingViewFunction()
        }
    }

    private func updateGraphingViewFunction() {
        guard graphingModel.equation != nil else { return }
        graphingView?.function = { [weak weakSelf = self] in CGFloat( weakSelf!.graphingModel.equation!( Double($0) ) ) }
    }

    func setEquation(description: String, equation: @escaping (Double) -> Double) {
        graphingModel.description = description
        graphingModel.equation = equation
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let savedGraphScale = CGFloat(UserDefaults.standard.double(forKey: GraphDefaultKeys.scale))
        if savedGraphScale != 0 {
            graphingView.scale = savedGraphScale
        }
        let savedGraphOrigin = CGPoint(x: UserDefaults.standard.double(forKey: GraphDefaultKeys.originX), y: UserDefaults.standard.double(forKey: GraphDefaultKeys.originY))
        if savedGraphOrigin != CGPoint.zero {
            graphingView.origin = savedGraphOrigin
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard graphingView != nil else { return }  // for some reason getting called before viewDidLoad()...
        UserDefaults.standard.set(Double(graphingView.scale), forKey: GraphDefaultKeys.scale)
        UserDefaults.standard.set(Double(graphingView.origin.x), forKey: GraphDefaultKeys.originX)
        UserDefaults.standard.set(Double(graphingView.origin.y), forKey: GraphDefaultKeys.originY)
    }

    override func viewWillLayoutSubviews() {
         graphingView.saveOriginToCenterDifference()
    }
    override func viewDidLayoutSubviews() {
         graphingView.applyOriginToCenterDifference()
    }
}

extension GraphingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view != otherGestureRecognizer.view {
            return false
        }
        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
}

fileprivate struct GraphDefaultKeys {
    static let scale = "graphScale"
    static let originX = "graphOriginX"
    static let originY = "graphOriginY"
}
