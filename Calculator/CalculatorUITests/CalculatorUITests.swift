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

    let labelNames = ["0", " "]

    let numpadButtonNames = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    let coreFunctionButtonNames = ["=", "C", "⌫"]
    let operationButtonNames = ["+", "-", "×", "÷", "±", "√", "∛", "sin", "cos", "%", "x²", "x³", "π", "e"]

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

    private func labelsExist(_ labelArray: [String], callingFile: StaticString = #file, callingLine: UInt = #line) {
        for label in labelArray {
            XCTAssert(app.staticTexts[label].exists, "\(label) label does not exist!", file: callingFile, line: callingLine)
        }
    }

    private func labelsOnScreen(_ labelArray: [String], callingFile: StaticString = #file, callingLine: UInt = #line) {
        let window = app.windows.element(boundBy: 0)
        for labelName in labelArray {
            let label = app.staticTexts[labelName]
            XCTAssert(window.frame.contains(label.frame), file: callingFile, line: callingLine)
        }
    }

    private func buttonsExist(_ buttonArray: [String], callingFile: StaticString = #file, callingLine: UInt = #line) {
        for button in buttonArray {
            XCTAssert(app.buttons[button].exists, "\(button) button does not exist!", file: callingFile, line:callingLine)
        }
    }

    private func buttonsOnScreen(_ buttonArray: [String], callingFile: StaticString = #file, callingLine: UInt = #line) {
        print("file: \(callingFile), line: \(callingLine)")
        let window = app.windows.element(boundBy: 0)
        for buttonName in buttonArray {
            let button = app.buttons[buttonName]
            XCTAssert(window.frame.contains(button.frame), file: callingFile, line: callingLine)
        }
    }

    func testLabelExists() {
        XCTAssert(app.staticTexts["0"].exists)
    }

    func testLabelReadable() {
        XCUIDevice.shared().orientation = .portrait
        sleep(2)
        XCTAssert(app.staticTexts["0"].frame.height >= 48)

        XCUIDevice.shared().orientation = .landscapeLeft
        sleep(2)
        XCTAssert(app.staticTexts["0"].frame.height >= 48)
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

    func testLabelsOnScreenWithRotation() {

        labelsExist(labelNames)

        XCUIDevice.shared().orientation = .portrait
        sleep(2)
        labelsOnScreen(labelNames)

        XCUIDevice.shared().orientation = .landscapeLeft
        sleep(2)
        labelsOnScreen(labelNames)

        XCUIDevice.shared().orientation = .landscapeRight
        sleep(2)
        labelsOnScreen(labelNames)
    }

    func testButtonsOnScreenWithRotation() {
        buttonsExist(numpadButtonNames)
        buttonsExist(coreFunctionButtonNames)
        buttonsExist(operationButtonNames)

        XCUIDevice.shared().orientation = .portrait
        sleep(2)
        buttonsOnScreen(numpadButtonNames)
        buttonsOnScreen(coreFunctionButtonNames)
        buttonsOnScreen(operationButtonNames)

        XCUIDevice.shared().orientation = .landscapeLeft
        sleep(2)
        buttonsOnScreen(numpadButtonNames)
        buttonsOnScreen(coreFunctionButtonNames)
        buttonsOnScreen(operationButtonNames)

        XCUIDevice.shared().orientation = .landscapeRight
        sleep(2)
        buttonsOnScreen(numpadButtonNames)
        buttonsOnScreen(coreFunctionButtonNames)
        buttonsOnScreen(operationButtonNames)
    }


    // Required Task #7

    func testA() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()

        XCTAssert(app.staticTexts["7.0 + ..."].exists)
        XCTAssert(app.staticTexts["7"].exists)

    }

    func testB() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()

        XCTAssert(app.staticTexts["7.0 + ..."].exists)
        XCTAssert(app.staticTexts["9"].exists)
    }

    func testC() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["7.0 + 9.0 ="].exists)
        XCTAssert(app.staticTexts["16.0"].exists)
    }

    func testD() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()

        XCTAssert(app.staticTexts["√(7.0 + 9.0) ="].exists)
        XCTAssert(app.staticTexts["4.0"].exists)
    }

    func testE() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["√(7.0 + 9.0) + 2.0 ="].exists)
        XCTAssert(app.staticTexts["6.0"].exists)
    }

    func testF() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()

        XCTAssert(app.staticTexts["7.0 + √(9.0) ..."].exists)
        XCTAssert(app.staticTexts["3.0"].exists)
    }

    func testG() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["7.0 + √(9.0) ="].exists)
        XCTAssert(app.staticTexts["10.0"].exists)
    }

    func testH() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["7.0 + 9.0 + 6.0 + 3.0 ="].exists)
        XCTAssert(app.staticTexts["25.0"].exists)
    }

    func testI() {
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["6.0 + 3.0 ="].exists)
        XCTAssert(app.staticTexts["9.0"].exists)
    }

    func testJ() {
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()

        XCTAssert(app.staticTexts["5.0 + 6.0 ="].exists)
        XCTAssert(app.staticTexts["73"].exists)
    }

    func testK() {
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        app.buttons["π"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["4.0 × π ="].exists)
        XCTAssert(app.staticTexts["12.5663706143592"].exists)
    }

    func testClear() {
        app.buttons["8"].tap()
        app.buttons["±"].tap()
        app.buttons["±"].tap()
        app.buttons["%"].tap()
        app.buttons["×"].tap()
        app.buttons["1"].tap()
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["%(±(±(8.0))) × 100.0 ="].exists)
        XCTAssert(app.staticTexts["8.0"].exists)

        app.buttons["C"].tap()
        // for label in labelNames {XCTAssert(app.staticTexts[label].exists)}
        XCTAssert(app.staticTexts["0.0"].exists)
        XCTAssert(app.staticTexts[" "].exists)

        app.buttons["8"].tap()
        XCTAssert(app.staticTexts["8"].exists)
    }

    func testBackspaceEnterAndDeleteAll() {
        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)

        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)

        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["123"].exists)

        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["12"].exists)

        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["1"].exists)

        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
    }

    func testBackspaceDuringOperations() {
        app.buttons["8"].tap()
        app.buttons["×"].tap()

        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts["8.0 × ..."].exists)
        XCTAssert(app.staticTexts["8"].exists)

        app.buttons["9"].tap()
        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts["8.0 × ..."].exists)
        XCTAssert(app.staticTexts["0"].exists)

        app.buttons["="].tap()
        XCTAssert(app.staticTexts["8.0 × ..."].exists)
        XCTAssert(app.staticTexts["0"].exists)

        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["⌫"].tap()
        XCTAssert(app.staticTexts["8.0 × 9.0 ="].exists)
        XCTAssert(app.staticTexts["72.0"].exists)
    }
}
