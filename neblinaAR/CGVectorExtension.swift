//
//  CGVectorExtension.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-21.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import UIKit
extension CGVector {

    init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }

    func normalized() -> CGVector {
        let len = length()
        return len>0 ? (self / len) : CGVector.zero
    }
    
    static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
            return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
        }
    
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
}

extension CGPoint {

    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }

    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }

    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

}
