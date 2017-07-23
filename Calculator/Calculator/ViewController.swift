//
//  ViewController.swift
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

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var mValue: UILabel!
    @IBOutlet weak var undoBackspace: UIButton!

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
        if display.text!.characters.count > 1 {
            display.text = String(display.text!.characters.dropLast())
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
    }

    private func updateMValue() {
        if let m = variables["M"] {
            displayFormatter.maximumFractionDigits = m.remainder(dividingBy: 1) == 0 ? 0 : DisplayFormat.maximumDecimalPlaces
            mValue.text = "M=" + displayFormatter.string(from: NSNumber(value: m))!
        } else {
            mValue.text = ""
        }
    }
}
