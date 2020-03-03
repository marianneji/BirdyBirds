//
//  Configuration.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 03/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}