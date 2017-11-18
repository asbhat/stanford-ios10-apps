//
//  CalculatorSplitViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 11/17/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit

class CalculatorSplitViewController: UISplitViewController {

    override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.childViewControllers.first
    }
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.childViewControllers.first
    }

}
