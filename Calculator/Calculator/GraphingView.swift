//
//  GraphingView.swift
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

@IBDesignable
class GraphingView: UIView {

    var origin: CGPoint! { didSet { setNeedsDisplay() } }

    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }

    var lineColor: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    var function: ((CGFloat) -> CGFloat)! { didSet { setNeedsDisplay() } }

    private var axes = AxesDrawer(color: UIColor.white)

    override func draw(_ rect: CGRect) {
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        axes.contentScaleFactor = contentScaleFactor
        axes.drawAxes(in: rect, origin: origin, pointsPerUnit: scale)
        drawGraph(in: rect, origin: origin, pointsPerUnit: scale)
    }

    private func drawGraph(in rect: CGRect, origin: CGPoint, pointsPerUnit: CGFloat) {
        guard function != nil else {
            return
        }

        let minPixelX = Int(rect.minX * contentScaleFactor)
        let maxPixelX = Int(rect.maxX * contentScaleFactor)
        let graphPath = UIBezierPath()
        var graphPoint = CGPoint()
        var cartesianPoint = CGPoint()
        var continuousGraph = false

        for pixelX in minPixelX...maxPixelX {
            graphPoint.x = CGFloat(pixelX) / contentScaleFactor
            cartesianPoint = graphPoint.toCartesianFromPoint(origin: origin, scale: scale)
            cartesianPoint.y = function(cartesianPoint.x)
            guard cartesianPoint.y.isNormal || cartesianPoint.y.isZero else {
                continuousGraph = false
                continue
            }
            graphPoint = cartesianPoint.toPointFromCartesian(origin: origin, scale: scale)
            guard rect.contains(graphPoint) else {
                continuousGraph = false
                continue
            }
            if continuousGraph {
                graphPath.addLine(to: graphPoint)
            } else {
                graphPath.move(to: graphPoint)
                continuousGraph = true
            }

        }

        lineColor.set()
        graphPath.lineWidth = lineWidth
        graphPath.stroke()
    }

    private var originToCenter: (dx: CGFloat, dy: CGFloat) = (0, 0)
    func saveOriginToCenterDifference() {
        if let o = origin {
            originToCenter = (o.x - bounds.midX, o.y - bounds.midY)
        }
    }
    func applyOriginToCenterDifference() {
        origin? = CGPoint(x: originToCenter.dx + bounds.midX, y: originToCenter.dy + bounds.midY)
    }
}

private extension CGPoint {
    func toCartesianFromPoint(origin: CGPoint, scale: CGFloat = 1.0) -> CGPoint {
        return CGPoint(x: (self.x - origin.x) / scale, y: (self.y + origin.y) / scale)
    }
    func toPointFromCartesian(origin: CGPoint, scale: CGFloat = 1.0) -> CGPoint {
        return CGPoint(x: origin.x + (self.x * scale), y: origin.y - (self.y * scale))
    }
}
