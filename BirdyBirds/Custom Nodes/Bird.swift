//
//  Bird.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 03/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

enum BirdType: String {
    case red, blue, yellow, gray
}

class Bird: SKSpriteNode {

    private var birdType: BirdType
    var grabbed = false
    var flying = false {
        didSet {
            if flying {
                physicsBody?.isDynamic = true
            }
        }
    }

    init(type: BirdType) {
        birdType = type


        let texture = SKTexture(imageNamed: type.rawValue + "1")
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
