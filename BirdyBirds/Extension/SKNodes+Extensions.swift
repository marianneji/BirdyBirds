//
//  SKNodes+Extensions.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 05/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

extension SKNode {

    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
}
