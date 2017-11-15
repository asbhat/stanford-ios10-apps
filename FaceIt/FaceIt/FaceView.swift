//
//  FaceView.swift
//  FaceIt
//
//  Created by Aditya Bhat on 7/8/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit

@IBDesignable  // can see it in the storyboard
class FaceView: UIView {

    @IBInspectable  // can see variables in the attributes inspector tab
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }  // do NOT call draw() directly, always use this instead

    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var lineColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }

    @IBInspectable
    var fillColor: UIColor = UIColor.yellow { didSet { setNeedsDisplay() } }

    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }

    @IBInspectable
    var mouthCurvature: Double = -0.5  // 1.0 is full smile and -1.0 is full frown

    @objc func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1  // only want to update based on incremental changes
        default:
            break
        }
    }

    @objc func zoom(byReactingTo tapPanRecoginizer: UITapThenPanGestureRecognizer) {
        switch  tapPanRecoginizer.state {
        case .changed, .ended:
            let translation = tapPanRecoginizer.translation(in: self)
            scale *= (1 + translation.x / 100.0 + translation.y / 100.0)
            tapPanRecoginizer.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }

    private var headRadius: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2 * scale
    }
    private var headCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)  // could also do convert(center, from: superview)
    }

    private enum Eye {
        case left
        case right
    }

    private func pathForEye(_ eye: Eye) -> UIBezierPath {

        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = headRadius / Ratios.headRadiusToEyeOffset
            var eyeCenter = headCenter
            eyeCenter.x += ((eye == .left ? -1 : 1) * eyeOffset)
            eyeCenter.y -= eyeOffset  // moves the eye up (negative is up)
            return eyeCenter
        }

        let eyeRadius = headRadius / Ratios.headRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)

        let path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }

        path.lineWidth = lineWidth

        return path
    }

    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = headRadius / Ratios.headRadiusToMouthWidth
        let mouthHeight = headRadius / Ratios.headRadiusToMouthHeight
        let mouthOffset = headRadius / Ratios.headRadiusToMouthOffset

        let mouthRect = CGRect(
            x: headCenter.x - mouthWidth / 2,
            y: headCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )

        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height  // make sure mouthCurvature is between 1 and -1
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)

        // let path = UIBezierPath(roundedRect: mouthRect, cornerRadius: mouthHeight / 2)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)

        path.lineWidth = lineWidth

        return path
    }

    private func pathForHead() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: headCenter, radius: headRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)  // angles are in Radians 🤷‍♂️
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        fillColor.set()
        pathForHead().fill()

        lineColor.set()
        pathForHead().stroke()
        pathForEye(.left).stroke()
        pathForEye(.left).fill()
        pathForEye(.right).stroke()
        pathForEye(.right).fill()
        pathForMouth().stroke()
    }

    // Good way to do constants
    private struct Ratios {
        static let headRadiusToEyeOffset: CGFloat = 3
        static let headRadiusToEyeRadius: CGFloat = 10
        static let headRadiusToMouthWidth: CGFloat = 1
        static let headRadiusToMouthHeight: CGFloat = 3
        static let headRadiusToMouthOffset: CGFloat = 3
    }
}
