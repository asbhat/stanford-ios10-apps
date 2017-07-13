//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Aditya Bhat on 6/5/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {

    var brain = CalculatorBrain()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetOperand() {
        brain.setOperand(8)

        XCTAssert(brain.result == 8)
        XCTAssert(brain.description == "8")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testConstant() {
        brain.performOperation("π")

        XCTAssert(brain.result == Double.pi)
        XCTAssert(brain.description == "π")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testNullaryOperation() {
        brain.performOperation("Rand")

        XCTAssert(brain.result! >= 0)
        XCTAssert(brain.result! <= 1)
        XCTAssert(brain.description == "Rand()")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testUnaryOperation() {
        brain.setOperand(8)
        brain.performOperation("x²")

        XCTAssert(brain.result == 64)
        XCTAssert(brain.description == "x²(8)")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testBinaryOperation() {
        brain.setOperand(8)
        brain.performOperation("÷")

        XCTAssertNil(brain.result)
        XCTAssert(brain.description == "8 ÷")
        XCTAssert(brain.resultIsPending)

        brain.setOperand(4)

        XCTAssert(brain.result == 4)
        XCTAssert(brain.description == "8 ÷")
        XCTAssert(brain.resultIsPending)

        brain.performOperation("=")

        XCTAssert(brain.result == 2)
        XCTAssert(brain.description == "8 ÷ 4")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testNullaryDuringBinary() {
        brain.setOperand(8)
        brain.performOperation("+")
        brain.performOperation("Rand")

        XCTAssert(brain.result! >= 0)
        XCTAssert(brain.result! <= 1)
        XCTAssert(brain.description == "8 +")
        XCTAssert(brain.resultIsPending)

        brain.performOperation("=")

        XCTAssert(brain.result! >= 8)
        XCTAssert(brain.result! <= 9)
        XCTAssert(brain.description == "8 + Rand()")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testMultipleConsecutiveBinary() {
        brain.setOperand(6)
        brain.performOperation("×")
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(4)
        brain.performOperation("×")
        brain.setOperand(3)
        brain.performOperation("=")

        XCTAssert(brain.result == 360)
        XCTAssert(brain.description == "6 × 5 × 4 × 3")
        XCTAssertFalse(brain.resultIsPending)
    }

    func testMultipleUnaryDuringSecondBinary() {
        brain.setOperand(8)
        brain.performOperation("-")

        brain.setOperand(81)
        brain.performOperation("√")
        XCTAssert(brain.result == 9)
        XCTAssert(brain.description == "8 - √(81)")
        XCTAssert(brain.resultIsPending)

        brain.performOperation("√")

        XCTAssert(brain.result == 3)
        XCTAssert(brain.description == "8 - √(√(81))")
        XCTAssert(brain.resultIsPending)
    }

    func testClear() {
        let beginningBrainResult = brain.result
        let beginningBrainDescription = brain.description
        let beginningBrainResultIsPending = brain.resultIsPending

        brain.setOperand(8)
        brain.performOperation("-")
        brain.setOperand(81)
        brain.performOperation("√")
        brain.performOperation("√")

        brain.clear()

        XCTAssert(brain.result == beginningBrainResult)
        XCTAssert(brain.description == beginningBrainDescription)
        XCTAssert(brain.resultIsPending == beginningBrainResultIsPending)
    }

    func testSetVariableOperand() {
        brain.setOperand(variable: "x")
        brain.performOperation("cos")

        XCTAssert(brain.description == "cos(x)")
        XCTAssert(brain.result == 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
