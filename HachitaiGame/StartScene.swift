//
//  StartScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class StartScene: SKScene {
    override func didMove(to view: SKView) {
        let newGameLabel = SKLabelNode(text: "START")
        let newGameButton = SKButton(color: UIColor.orange, size: CGSize(width: 100, height: 100))
        newGameButton.setCallback {
            
        }
        newGameButton.addChild(newGameLabel)
        self.addChild(newGameButton)
    }
}
