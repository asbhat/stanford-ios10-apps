//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 6/5/17.
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

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var mValue: UILabel!
    @IBOutlet weak var undoBackspace: UIButton!
    @IBOutlet weak var graph: UIButton!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private let displayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    private struct DisplayFormat {
        static let maximumDecimalPlaces = 6
    }

    private var brain = CalculatorBrain()

    private var userIsInTheMiddleOfTyping = false {
        willSet {
            if newValue {
                UIView.performWithoutAnimation {
                    undoBackspace.setTitle("⌫", for: .normal)
                    undoBackspace.layoutIfNeeded()
                }
            } else {
                UIView.performWithoutAnimation {
                    undoBackspace.setTitle("Undo", for: .normal)
                    undoBackspace.layoutIfNeeded()
                }
            }
        }
    }

    private var variables = [String : Double]()

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !(digit == "." && textCurrentlyInDisplay.contains(".")) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }

    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            displayFormatter.maximumFractionDigits = newValue.remainder(dividingBy: 1) == 0 ? 0 : DisplayFormat.maximumDecimalPlaces
            display.text = displayFormatter.string(from: NSNumber(value: newValue))
        }
    }

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }

        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        evaluateAndUpdate()
    }

    @IBAction func clear() {
        brain.clear()
        variables.removeAll()
        evaluateAndUpdate()
        userIsInTheMiddleOfTyping = false
    }

    private func backspace() {
        if display.text!.count > 1 {
            display.text = String(display.text!.dropLast())
        } else {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        }
    }

    @IBAction func undo() {
        if userIsInTheMiddleOfTyping {
            backspace()
        } else {
            brain.undo()
            evaluateAndUpdate()
        }
    }

    @IBAction func setM(_ sender: UIButton) {
        variables["M"] = displayValue
        evaluateAndUpdate()
        userIsInTheMiddleOfTyping = false
    }

    @IBAction func useVariable(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        evaluateAndUpdate()
    }

    private func evaluateAndUpdate() {
        let evaluation = brain.evaluate(using: variables)
        history.text = evaluation.description.isEmpty ? " " : evaluation.description + (evaluation.isPending ? " ..." : " =")
        if evaluation.result != nil {
            displayValue = evaluation.result!
        } else if evaluation.description.isEmpty {
            displayValue = 0
        }
        if evaluation.errorMessage != nil {
            display.text = evaluation.errorMessage
        }
        updateMValue()
        updateGraphAbility()
    }

    private func updateMValue() {
        if let m = variables["M"] {
            displayFormatter.maximumFractionDigits = m.remainder(dividingBy: 1) == 0 ? 0 : DisplayFormat.maximumDecimalPlaces
            mValue.text = "M=" + displayFormatter.string(from: NSNumber(value: m))!
        } else {
            mValue.text = ""
        }
    }

    private var canGraph = false {
        willSet {
            UIView.performWithoutAnimation {
                graph.alpha = newValue ? 1.0 : 0.5
                graph.layoutIfNeeded()
            }
        }
    }
    private func updateGraphAbility() {
        let evaluation = brain.evaluate(using: ["M": 1])
        canGraph = !evaluation.isPending && !evaluation.description.isEmpty && evaluation.errorMessage == nil
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "graph" {
            return canGraph
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController ?? destinationVC
        }
        if let graphingVC = destinationVC as? GraphingViewController {
            let brainCopy = brain  // copied so additional changes don't affect the graph
            let description = brainCopy.evaluate(using: ["M": 1]).description
            graphingVC.setEquation(description: description) {
                brainCopy.evaluate(using: ["M": $0] ).result ?? 0
            }
            graphingVC.navigationItem.title = description
        }
    }
}

@IBDesignable
extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set (newRadius) {
            layer.cornerRadius = newRadius
            layer.masksToBounds = newRadius > 0
        }
    }
}
