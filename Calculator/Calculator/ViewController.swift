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

    private let displayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    private struct DisplayFormat {
        static let maximumDecimalPlaces = 6
    }

    private var brain = CalculatorBrain()

    private var userIsInTheMiddleOfTyping = false

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

        if let result = brain.result {
            displayValue = result
        }
        history.text = brain.description == " " ? " " : brain.description + (brain.resultIsPending ? " ..." : " =")
    }

    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        displayValue = brain.result ?? 0
        history.text = brain.description
        userIsInTheMiddleOfTyping = false
    }

    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if display.text!.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
            } else {
                display.text = "0"
                userIsInTheMiddleOfTyping = false
            }
        }
    }
}
