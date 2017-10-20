//
//  UITapThenPanGestureRecognizer.swift
//  FaceIt
//
//  Created by Aditya Bhat on 10/13/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

struct TouchPoint {
    var point: CGPoint
    var view: UIView?
}

class UITapThenPanGestureRecognizer: UIGestureRecognizer {
    private var anchor: TouchPoint?
    private var lastTouch: TouchPoint?

    func translation(in view: UIView?) -> CGPoint {
        guard view == anchor?.view else {
            return CGPoint.zero
        }
        if anchor != nil && lastTouch != nil {
            return CGPoint(x: lastTouch!.point.x - anchor!.point.x, y: lastTouch!.point.y - anchor!.point.y)
        }
        return CGPoint.zero
    }

    func setTranslation(_ translation: CGPoint, in view: UIView?) {
        guard view == anchor?.view else {
            return
        }
        guard anchor != nil else {
            return
        }
        lastTouch = lastTouch ?? anchor
        anchor!.point = CGPoint(x: translation.x + lastTouch!.point.x, y: translation.y + lastTouch!.point.y)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        // super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            self.state = .failed
            return
        }

        guard touches.first?.tapCount == 2 else {
            self.state = .failed
            return
        }

        anchor = TouchPoint(point: touches.first!.location(in: self.view), view: self.view)
        state = .began
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        lastTouch = TouchPoint(point: touches.first!.location(in: self.view), view: self.view)
        state = .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        lastTouch = TouchPoint(point: touches.first!.location(in: self.view), view: self.view)
        state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        anchor = nil
        lastTouch = nil
        state = .cancelled
    }

    override func reset() {
        anchor = nil
        lastTouch = nil
    }
}
