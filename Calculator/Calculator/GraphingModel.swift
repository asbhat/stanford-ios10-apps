//
//  GraphingModel.swift
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

import Foundation

struct GraphingModel: CustomStringConvertible {

    var description: String = "cos(x)"  // temp default value
    var equation: ((Double) -> Double)? = cos  // temp default value

    /**
     returns the y cartesian coordinate from the x
     - parameter x: x cartesian coordinate
    */
    func calculateY(from x: Double) -> Double? {
        return equation?(x)
    }

}
