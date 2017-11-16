//
//  GraphingViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 11/9/17.
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

import UIKit

class GraphingViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private var graphingModel = GraphingModel() {
        didSet {
            updateGraphingViewFunction()
        }
    }
    // var graphingModel: (equation: ((Double) -> Double)?, description: String?)

    @IBOutlet weak var graphingView: GraphingView! {
        didSet {
            updateGraphingViewFunction()
        }
    }

    private func updateGraphingViewFunction() {
        guard graphingModel.equation != nil else {
            return
        }
        graphingView?.function = { [weak weakSelf = self] in CGFloat( weakSelf!.graphingModel.equation!( Double($0) ) ) }
    }

    func setEquation(description: String, equation: @escaping (Double) -> Double) {
        graphingModel.description = description
        graphingModel.equation = equation
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
