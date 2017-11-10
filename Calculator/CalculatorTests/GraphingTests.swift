//
//  GraphingTests.swift
//  CalculatorTests
//
//  Created by Aditya Bhat on 11/9/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import XCTest
@testable import Calculator

class GraphingTests: XCTestCase {

    var model = GraphingModel(description: "cos(x)", equation: cos)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testChangeEquation() {
        model.equation = sin
        model.description = "sin(x)"

        XCTAssertEqual(model.calculateY(from: 0), 0)
        XCTAssertEqual(model.calculateY(from: Double.pi/2), 1)
        XCTAssertEqual("\(model)", "sin(x)")
    }

    func testModelStillOriginal() {
        XCTAssertEqual(model.calculateY(from: 0), 1)
        XCTAssertEqual(model.calculateY(from: Double.pi/2)!, 0.0, accuracy: 0.0000000001)
        XCTAssertEqual("\(model)", "cos(x)")
    }

    /*
    func testOnTheFlyEquation() {
        XCTAssertEqual(model.calculateY(from: 2, using: {pow($0, 2)}), 4)
    }
    */

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
