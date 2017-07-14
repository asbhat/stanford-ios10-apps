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

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 8)
        XCTAssert(description == "8")
        XCTAssertFalse(isPending)
    }

    func testConstant() {
        brain.performOperation("π")

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result == Double.pi)
        XCTAssert(description == "π")
        XCTAssertFalse(isPending)
    }

    func testNullaryOperation() {
        brain.performOperation("Rand")

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result! >= 0)
        XCTAssert(result! <= 1)
        XCTAssert(description == "Rand()")
        XCTAssertFalse(isPending)
    }

    func testUnaryOperation() {
        brain.setOperand(8)
        brain.performOperation("x²")

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 64)
        XCTAssert(description == "x²(8)")
        XCTAssertFalse(isPending)
    }

    func testBinaryOperation() {
        brain.setOperand(8)
        brain.performOperation("÷")

        var (result, isPending, description) = brain.evaluate()
        XCTAssertNil(result)
        XCTAssert(description == "8 ÷")
        XCTAssert(isPending)

        brain.setOperand(4)

        (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 4)
        XCTAssert(description == "8 ÷")
        XCTAssert(isPending)

        brain.performOperation("=")

        (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 2)
        XCTAssert(description == "8 ÷ 4")
        XCTAssertFalse(isPending)
    }

    func testNullaryDuringBinary() {
        brain.setOperand(8)
        brain.performOperation("+")
        brain.performOperation("Rand")

        var (result, isPending, description) = brain.evaluate()
        XCTAssert(result! >= 0)
        XCTAssert(result! <= 1)
        XCTAssert(description == "8 +")
        XCTAssert(isPending)

        brain.performOperation("=")

        (result, isPending, description) = brain.evaluate()
        XCTAssert(result! >= 8)
        XCTAssert(result! <= 9)
        XCTAssert(description == "8 + Rand()")
        XCTAssertFalse(isPending)
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

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 360)
        XCTAssert(description == "6 × 5 × 4 × 3")
        XCTAssertFalse(isPending)
    }

    func testMultipleUnaryDuringSecondBinary() {
        brain.setOperand(8)
        brain.performOperation("-")
        brain.setOperand(81)
        brain.performOperation("√")

        var (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 9)
        XCTAssert(description == "8 - √(81)")
        XCTAssert(isPending)

        brain.performOperation("√")

        (result, isPending, description) = brain.evaluate()
        XCTAssert(result == 3)
        XCTAssert(description == "8 - √(√(81))")
        XCTAssert(isPending)
    }

    func testClear() {
        let (beginningBrainResult, beginningBrainResultIsPending, beginningBrainDescription) = brain.evaluate()

        brain.setOperand(8)
        brain.performOperation("-")
        brain.setOperand(81)
        brain.performOperation("√")
        brain.performOperation("√")

        brain.clear()

        let (result, isPending, description) = brain.evaluate()
        XCTAssert(result == beginningBrainResult)
        XCTAssert(description == beginningBrainDescription)
        XCTAssert(isPending == beginningBrainResultIsPending)
    }

    func testSetVariableOperand() {
        brain.setOperand(variable: "x")
        brain.performOperation("cos")

        let (result, _, description) = brain.evaluate()
        XCTAssert(description == "cos(x)")
        XCTAssert(result == 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
