//
//  CalculatorSplitViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 11/17/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit

class CalculatorSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.childViewControllers.first
    }
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.childViewControllers.first
    }

}

extension CalculatorSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let secondaryNavigationController = secondaryViewController as? UINavigationController,
            let _ = secondaryNavigationController.visibleViewController as? GraphingViewController {
            return true
        }
        return false
    }
}
