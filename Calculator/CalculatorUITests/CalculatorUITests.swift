//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Aditya Bhat on 6/5/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLabelExists() {
        XCTAssert(app.staticTexts["0"].exists)
    }

    // Required Task #2

    func testOnlyOneFloatingPoint() {

        app.buttons["1"].tap()
        app.buttons["."].tap()
        app.buttons["."].tap()
        app.buttons["."].tap()  // one more for good measure
        app.buttons["5"].tap()

        XCTAssert(app.staticTexts["1.5"].exists)
    }

    func testNicelyHandleFirstPeriodTap() {

        app.buttons["."].tap()
        app.buttons["."].tap()

        XCTAssert(app.staticTexts["0."].exists)
    }

}
