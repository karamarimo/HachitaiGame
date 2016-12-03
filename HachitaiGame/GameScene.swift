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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let playerSpeed: CGFloat = 200.0
    
    var enemy: EnemyNode!
    
    var blocks: [ObstacleSpriteNode] = []
    
    var player: PlayerNode!
    
    var goal: GoalNode!
    
    var playerController: PlayerControllerNode!
    var enemyController: EnemyManager!
    
    var time: TimeInterval = 0
    var startTime: TimeInterval = 0
    var started: Bool = false
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white
        self.physicsWorld.contactDelegate = self
        
        let txt = SKTexture(imageNamed: "wall")
        let block1 = ObstacleSpriteNode(rect: CGRect(x: 200, y: 200, width: 150, height: 20), texture: txt)
        block1.zRotation = CGFloat(M_PI_4)
        blocks.append(block1)
        let block2 = ObstacleSpriteNode(rect: CGRect(x: 250, y: 300, width: 20, height: 100), texture: txt)
        block2.zRotation = CGFloat(M_PI / 3)
        blocks.append(block2)
        let block3 = ObstacleSpriteNode(rect: CGRect(x: 100, y: 450, width: 100, height: 20), texture: txt)
        blocks.append(block3)
        let block4 = ObstacleSpriteNode(rect: CGRect(x: 50, y: 400, width: 20, height: 100), texture: txt)
        block4.zRotation = CGFloat(M_PI / 6)
        blocks.append(block4)
        for block in blocks { self.addChild(block) }
        
        
        enemy = EnemyNode()
        enemy.position = CGPoint(x: 50, y: 300)
        self.addChild(enemy)
        
        player = PlayerNode()
        self.addChild(player)
        player.position = CGPoint(x: 50, y: 50)
        
        playerController = PlayerControllerNode()
        playerController.player = player
        self.addChild(playerController)
        playerController.anchorPoint = CGPoint.zero
        playerController.position = CGPoint.zero
        playerController.size = self.size
        
        enemyController = EnemyManager(enemies: [enemy], player: player, obstacles: blocks)
        
        SwiftEventBus.onMainThread(self, name: GameConst.Enemy.foundPlayer) { (ntf: Notification!) in
            self.restartScene()
        }
        
        goal = GoalNode(position: CGPoint(x: 300, y: 500), size: CGSize(width: 30, height: 30))
        self.addChild(goal)
        
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
        if (started) {
            time = currentTime - startTime
        } else {
            startTime = currentTime
            started = true
        }
    }
    
    // Called right before a frame is rendered
    override func didFinishUpdate() {
        playerController.update()
        enemyController.update()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let cat_set: Set<UInt32> = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        // when player reaches the goal
        if cat_set.contains(CollisionBitmask.player)
            && cat_set.contains(CollisionBitmask.goal) {
            goToResultScene()
        }
        
        // when player collides with an enemy
        if cat_set.contains(CollisionBitmask.player)
            && cat_set.contains(CollisionBitmask.enemy) {
            restartScene()
        }
    }
    
    func restartScene() {
        cleanScene()
//        self.removeAllChildren()
        let newScene = GameScene(size: self.view!.frame.size)
        self.view!.presentScene(newScene, transition: SKTransition.flipVertical(withDuration: 0.5))
    }
    
    func goToResultScene() {
        cleanScene()
        let score: Int = time > 5 ? 0 : Int(round((5 - time) * 100))
        let newScene = ResultScene(size: self.view!.frame.size, score: score)
        self.view!.presentScene(newScene, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
    }
    
    func cleanScene() {
        SwiftEventBus.post(GameConst.Game.sceneFinished)
        SwiftEventBus.unregister(self)
    }
}
