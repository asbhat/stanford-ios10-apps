//
//  UITapThenPanGestureRecognizer.swift
//  FaceIt
//
//  Created by Aditya Bhat on 10/13/17.
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
