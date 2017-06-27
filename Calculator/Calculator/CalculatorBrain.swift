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
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

    private var accumulator: Double?

    private var operations: Dictionary<String, Operation> = [
        "π"     :   Operation.constant(Double.pi),
        "e"     :   Operation.constant(M_E),
        "√"     :   Operation.unaryOperation(sqrt),
        "cos"   :   Operation.unaryOperation(cos),
        "±"     :   Operation.unaryOperation({ -$0 }),
        "%"     :   Operation.unaryOperation({ $0 / 100.0 }),
        "x²"    :   Operation.unaryOperation({ pow($0, 2) }),
        "×"     :   Operation.binaryOperation({ $0 * $1 }),
        "÷"     :   Operation.binaryOperation({ $0 / $1 }),
        "+"     :   Operation.binaryOperation({ $0 + $1 }),
        "-"     :   Operation.binaryOperation({ $0 - $1 }),
        "="     :   Operation.equals
    ]

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }

    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

    var result: Double? {
        get {
            return accumulator
        }
    }

    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
}
