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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
