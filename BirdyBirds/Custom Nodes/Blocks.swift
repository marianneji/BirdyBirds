//
//  Blocks.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 03/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

enum BlockType: String {
    case stone, glass, wood
}

class Blocks: SKSpriteNode {

    var type: BlockType
    var health: Int
    let damageThreshold: Int

    init(type: BlockType) {
        self.type = type
        switch type {
        case .wood:
            health = 200
        case .stone:
            health = 500
        case .glass:
            health = 50
        }
        damageThreshold = health / 2

        super.init(texture: nil, color: .clear, size: CGSize.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategories.block
        physicsBody?.contactTestBitMask = PhysicsCategories.all
        physicsBody?.collisionBitMask = PhysicsCategories.all
    }

}
