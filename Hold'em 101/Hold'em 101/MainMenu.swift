//
//  MainMenu.swift
//  Hold'em 101
//
//  Created by Devin Craig on 3/9/21.
//

import SpriteKit

class MainMenu: SKScene {

    /* UI Connections */
    var tutorialPlay: MSButtonNode!

    override func didMove(to view: SKView) {
        /* Setup your scene here */

        /* Set UI connections */
        
        tutorialPlay = self.childNode(withName: "tutorialPlay") as? MSButtonNode
        
        tutorialPlay.selectedHandler = {
            self.loadGame()
        }

    }

    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        /* 2) Load Game scene */
        guard let scene = GameScene(fileNamed:"GameScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }

        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
}
