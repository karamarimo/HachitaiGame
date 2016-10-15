//
//  GameScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016 admin. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftEventBus

class GameScene: SKScene {
    
    let playerSpeed: CGFloat = 200.0
    
    var enemy: EnemyNode!
    
    var blocks: [ObstacleSpriteNode] = []
    
    var player: PlayerNode!
    
    let playerController = PlayerControllerNode()
    var enemyController: EnemyManager!
    
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white

        let block1 = ObstacleSpriteNode(rect: CGRect(x: 150, y: 200, width: 150, height: 20), texture: nil)
        blocks.append(block1)
        let block2 = ObstacleSpriteNode(rect: CGRect(x: 250, y: 300, width: 20, height: 200), texture: nil)
        blocks.append(block2)
        for block in blocks { self.addChild(block) }
        block1.zRotation = CGFloat(M_PI_4)
        
        
        enemy = EnemyNode()
        enemy.position = CGPoint(x: 50, y: 300)
        self.addChild(enemy)
        
        player = PlayerNode()
        self.addChild(player)
        player.position = CGPoint(x: 50, y: 50)
        
        playerController.player = player
        self.addChild(playerController)
        playerController.anchorPoint = CGPoint.zero
        playerController.position = CGPoint.zero
        playerController.size = self.size
        
        enemyController = EnemyManager(enemies: [enemy], player: player, obstacles: blocks)
        
        SwiftEventBus.onMainThread(self, name: GameConst.Enemy.foundPlayer) { (ntf: Notification!) in
            self.restartScene()
        }
        
        // TODO: remove this
        // for debuggig
        let touchPositionLabel = SKLabelNode()
        self.addChild(touchPositionLabel)
        touchPositionLabel.position = CGPoint(x: 30, y: 30)
        touchPositionLabel.text = "X: | Y:"
        touchPositionLabel.fontColor = SKColor.lightGray
        touchPositionLabel.fontName = "Arial"
        touchPositionLabel.fontSize = 10
        touchPositionLabel.horizontalAlignmentMode = .left
        SwiftEventBus.onMainThread(self, name: GameConst.UI.touchPositionChanged) { (ntf: Notification!) in
            if let point = ntf.object as? CGPoint {
                touchPositionLabel.text = "X:\(point.x) | Y:\(point.y)"
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerController.update()
        enemyController.update()
    }
    
    
    func restartScene() {
        SwiftEventBus.post(GameConst.Game.sceneFinished)
        SwiftEventBus.unregister(self)
//        self.removeAllChildren()
        let newScene = GameScene(size: self.view!.frame.size)
        self.view!.presentScene(newScene, transition: SKTransition.flipVertical(withDuration: 0.5))
    }
}
