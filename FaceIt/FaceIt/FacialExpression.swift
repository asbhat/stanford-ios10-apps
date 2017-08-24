//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Aditya Bhat on 8/22/17.
//  Copyright © 2017 Aditya Bhat. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }

    enum Mouth: Int {
        case frown
        case grimmace
        case neutral
        case grin
        case smile

        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
    }

    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }

    let eyes: Eyes
    let mouth: Mouth
}
