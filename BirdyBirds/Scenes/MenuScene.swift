//
//  MenuScene.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 05/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?

    override func didMove(to view: SKView) {
        setupMenu()
    }

    func setupMenu() {

        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1)
        background.zPosition = ZPosition.background
        addChild(background)

        let button = SpriteKitButton(defaultButtonImage: "playButton", action: goTOLevelScene, index: 0)
        button.position = CGPoint(x: frame.midX, y: frame.midY * 0.8)
        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        button.zPosition = ZPosition.hudLabel
        addChild(button)
    }

    func goTOLevelScene(_: Int) {
        sceneManagerDelegate?.presentLevelScene()
    }
}
