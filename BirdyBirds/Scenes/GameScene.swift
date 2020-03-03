//
//  GameScene.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 03/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case ready, flying, finished, animating
}

class GameScene: SKScene {

    private let gameCamera = GameCamera()

    private var panRecognizer = UIPanGestureRecognizer()
    private var pinchRecognizer = UIPinchGestureRecognizer()

    private var mapNode = SKTileMapNode()
    private var roundState = RoundState.ready
    private var maxScale: CGFloat = 0

    private var bird = Bird(type: .red)
    private var birds = [
        Bird(type: .red),
        Bird(type: .blue),
        Bird(type: .yellow),
        Bird(type: .gray)
    ]

    let anchor = SKNode()
    
    override func didMove(to view: SKView) {
        setupLevel()
        setupGestureRecognizers()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else { return }
        switch roundState {
        case .ready:
            if let touch = touches.first {
                let location = touch.location(in: self)
                if bird.contains(location) {
                    panRecognizer.isEnabled = false
                    bird.grabbed = true
                    bird.position = location
                }
            }
        case .flying:
            break
        case .finished:
            roundState = .animating
            let moveCameraBachAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2)
            moveCameraBachAction.timingMode = .easeInEaseOut
            gameCamera.run(moveCameraBachAction) {
                self.panRecognizer.isEnabled = true
                self.addBird()
            }
        case .animating:
            break
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if bird.grabbed {
                let location = touch.location(in: self)
                bird.position = location
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bird.grabbed {
            gameCamera.setConstraints(with: self, and: mapNode.frame, to: bird)
            bird.grabbed = false
            bird.flying = true
            roundState = .flying
            constraintToAnchor(active: false)
            let dx = anchor.position.x - bird.position.x
            let dy = anchor.position.y - bird.position.y
            let impulse = CGVector(dx: dx, dy: dy)
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
        }
    }

    func setupLevel() {
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.width / frame.size.width
        }
        addCamera()

        for child in mapNode.children {
            if let child = child as? SKSpriteNode {
                guard let name = child.name else { continue }
                if !["wood", "stone", "glass"].contains(name) { continue }
                guard let type = BlockType(rawValue: name) else { continue }
                let block = Blocks(type: type)
                block.size = child.size
                block.position = child.position
                block.color = .brown
                block.zPosition = ZPosition.obstacles
                block.createPhysicsBody()
                mapNode.addChild(block)
                child.color = .clear
            }
        }
        let ground = mapNode.frame.size.height - mapNode.tileSize.height
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: ground)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategories.edge
        physicsBody?.contactTestBitMask = PhysicsCategories.bird | PhysicsCategories.block
        physicsBody?.collisionBitMask = PhysicsCategories.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2)
        addChild(anchor)
        addBird()
    }

    func addBird() {

        if birds.isEmpty {
            print("no more birds")
            return
        }
        roundState = .ready
        bird = birds.removeFirst()
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategories.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategories.all
        bird.physicsBody?.collisionBitMask = PhysicsCategories.block | PhysicsCategories.edge
        bird.physicsBody?.isDynamic = false
        bird.position = anchor.position
        addChild(bird)
        constraintToAnchor(active: true)
    }

    fileprivate func constraintToAnchor(active: Bool) {
        if active {
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width * 3)
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor)
            bird.constraints = [positionConstraint]
        } else {
            bird.constraints?.removeAll()
        }
    }

    override func didSimulatePhysics() {
        guard let physicsBody = bird.physicsBody else { return }
        if roundState == .flying && physicsBody.isResting {
            gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            bird.removeFromParent()
            roundState = .finished
        }
    }

    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }

    func addCamera() {
        guard let view = view else { return }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        
        camera = gameCamera
        gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)

        
    }
}

extension GameScene {
    @objc func pan(_ sender: UIPanGestureRecognizer) {
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }

    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        guard let view = view else { return }
        if sender.numberOfTouches == 2 {
            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let convertedScale = 1 / sender.scale
                let newScale = gameCamera.yScale * convertedScale

                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }


                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale
                let newPosition = gameCamera.position + locationDelta
                gameCamera.position = newPosition
                sender.scale = 1
                gameCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            }
        }
    }
}
