//
//  Popup.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 05/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

protocol PopupButtonDelegate {
    func menuTapped()
    func nextTapped()
    func retryTapped()
}

struct PopupButtons {
    static let menu = 0
    static let next = 1
    static let retry = 2
}

class Popup: SKSpriteNode {

    let type: Int
    var popupButtonDelegate: PopupButtonDelegate?

    init(type:Int, size: CGSize) {
        self.type = type
        super.init(texture: nil, color: .clear, size: size)
        setupPopup()
    }
    func setupPopup() {
        let background = type == 0 ? SKSpriteNode(imageNamed: "popupcleared") : SKSpriteNode(imageNamed: "popupfailed")
        background.aspectScale(to: size, width: false, multiplier: 0.5)

        let menuButton = SpriteKitButton(defaultButtonImage: "popmenu", action: popupButtonHandler, index: PopupButtons.menu)
        let nextButton = SpriteKitButton(defaultButtonImage: "popnext", action: popupButtonHandler, index: PopupButtons.next)
        let retryButton = SpriteKitButton(defaultButtonImage: "popretry", action: popupButtonHandler, index: PopupButtons.retry)
        nextButton.isUserInteractionEnabled = type == 0 ? true : false

        menuButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        nextButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        retryButton.aspectScale(to: background.size, width: true, multiplier: 0.2)

        let buttonWidthOffSet = retryButton.size.width/2
        let buttonHeightOffSet = retryButton.size.height/2
        let backgroundWidthOffSet = background.size.width/2
        let backgroundHeightOffSet = background.size.height/2

        menuButton.position = CGPoint(x: -backgroundWidthOffSet + buttonWidthOffSet, y: -backgroundHeightOffSet - buttonHeightOffSet)
        nextButton.position = CGPoint(x: 0, y: -backgroundHeightOffSet - buttonHeightOffSet)
        retryButton.position = CGPoint(x: backgroundWidthOffSet - buttonWidthOffSet, y: -backgroundHeightOffSet - buttonHeightOffSet)
        background.position = CGPoint(x: 0, y: buttonHeightOffSet)

        addChild(menuButton)
        addChild(nextButton)
        addChild(retryButton)
        addChild(background)


    }

    func popupButtonHandler(index: Int) {
        switch index {
        case PopupButtons.menu:
            popupButtonDelegate?.menuTapped()
        case PopupButtons.next:
            popupButtonDelegate?.nextTapped()
        case PopupButtons.retry:
            popupButtonDelegate?.retryTapped()
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
