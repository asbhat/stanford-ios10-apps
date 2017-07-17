//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aditya Bhat on 6/6/17.
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

import Foundation

struct CalculatorBrain {
    // structs have no inheritance (classes do)
    //   are passed by value (classes are passed by reference)
    //   automatically initialized (classes need an initializer)
    //   need to mark funcs as 'mutating' if modifies the struct (don't need to in classes)

    private enum Operation {
        case constant(Double)
        case nullaryOperation(() -> Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

    private enum SequenceItem {
        case operand((value: Double, text: String))
        case operation(String)
        case variable(String)
    }

    private let descriptionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        return formatter
    }()

    // Better way to do constants
    private struct OperandFormat {
        static let maximumDecimalPlaces = 6
    }

    private var sequence = [SequenceItem]()

    private var operations: Dictionary<String, Operation> = [
        "π"     :   Operation.constant(Double.pi),
        "e"     :   Operation.constant(M_E),
        "Rand"  :   Operation.nullaryOperation({ Double(arc4random()) / Double(UINT32_MAX) }),
        "√"     :   Operation.unaryOperation(sqrt),
        "∛"     :   Operation.unaryOperation({ pow($0, 1.0/3.0) }),
        "sin"   :   Operation.unaryOperation(sin),
        "cos"   :   Operation.unaryOperation(cos),
        "±"     :   Operation.unaryOperation({ -$0 }),
        "%"     :   Operation.unaryOperation({ $0 / 100.0 }),
        "x²"    :   Operation.unaryOperation({ pow($0, 2) }),
        "x³"    :   Operation.unaryOperation({ pow($0, 3) }),
        "×"     :   Operation.binaryOperation({ $0 * $1 }),
        "÷"     :   Operation.binaryOperation({ $0 / $1 }),
        "+"     :   Operation.binaryOperation({ $0 + $1 }),
        "-"     :   Operation.binaryOperation({ $0 - $1 }),
        "="     :   Operation.equals
    ]

    mutating func performOperation(_ symbol: String) {
        sequence.append(.operation(symbol))
    }

    mutating func setOperand(_ operand: Double) {
        descriptionFormatter.maximumFractionDigits = operand.remainder(dividingBy: 1) == 0 ? 0 : OperandFormat.maximumDecimalPlaces
        sequence.append(.operand((value: operand, text: descriptionFormatter.string(from: NSNumber(value: operand))!)))
    }

    mutating func setOperand(variable named: String) {
        sequence.append(.variable(named))
    }

    func evaluate(using variables: [String : Double]? = nil) -> (result: Double?, isPending: Bool, description: String) {
        var result: (value: Double?, text: String?)
        var description = ""

        var pendingBinaryOperation: PendingBinaryOperation?
        var isPending: Bool {
            return pendingBinaryOperation != nil
        }

        func evaluate(_ sequence: [SequenceItem]) {
            for item in sequence {
                switch item {
                case .operand(let (value, text)):
                    result = (value, text)
                    if (!isPending) { description = result.text! }
                case .operation(let symbol):
                    evaluate(operation: symbol)
                case .variable(let name):
                    result = (variables?[name] ?? 0, name)
                }
            }
        }

        func evaluate(operation symbol: String) {
            if let operation = operations[symbol] {
                switch operation {
                case .constant(let value):
                    result = (value, symbol)
                    if (!isPending) { description = result.text! }
                case .nullaryOperation(let function):
                    result = (function(), "\(symbol)()")
                    if (!isPending) { description = result.text! }
                case .unaryOperation(let function):
                    if let oldResult = result.value {
                        let oldText = result.text!
                        result = (function(oldResult), "\(symbol)(\(oldText))")
                        if (!isPending) {
                            description = result.text!
                        } else {
                            if description.hasSuffix(oldText) {
                                description = description.replace(ending: oldText, with: result.text!)!
                            } else {
                                description += " \(result.text!)"
                            }
                        }
                    }
                case .binaryOperation(let function):
                    if result.value != nil {
                        evaluatePendingBinaryOperation()
                        description = "\(result.text!) \(symbol)"
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: result.value!)
                        result = (nil, nil)
                    }
                case .equals:
                    evaluatePendingBinaryOperation()
                }
            }
        }

        func evaluatePendingBinaryOperation() {
            if pendingBinaryOperation != nil && result.value != nil {
                if !description.hasSuffix(" \(result.text!)") {
                    description += " \(result.text!)"
                }
                result = (pendingBinaryOperation!.evaluate(with: result.value!), description)
                pendingBinaryOperation = nil
            }
        }

        struct PendingBinaryOperation {
            let function: (Double, Double) -> Double
            let firstOperand: Double

            func evaluate(with secondOperand: Double) -> Double {
                return function(firstOperand, secondOperand)
            }
        }

        evaluate(sequence)

        return (result.value, isPending, description)
    }

    @available(*, deprecated, message: "Please use evaluate().result going forward")
    var result: Double? {
        return evaluate().result
    }

    @available(*, deprecated, message: "Please use evaluate().isPending going forward")
    var resultIsPending: Bool {
        return evaluate().isPending
    }

    @available(*, deprecated, message: "Please use evaluate().description going forward")
    var description: String {
        return evaluate().description
    }

    mutating func clear() {
        sequence.removeAll()
    }

    mutating func undo() {
        if (sequence.count > 0) { sequence.removeLast() }
    }
}

private extension String {
    func replace(ending: String, with replacement: String) -> String? {
        guard self.hasSuffix(ending) else {
            return nil
        }
        return String(self.characters.dropLast(ending.characters.count)) + replacement
    }
}
