//
//  GameScene.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016年 admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    let playerSpeed: CGFloat = 200.0
    
    var enemy: SKSpriteNode!
    
    var block: SKSpriteNode!
    var block2: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        player = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 30, height: 30))
        player.position = CGPoint(x: 100, y: 100)
        player.zPosition = 10.0
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        self.addChild(player)
        
        block = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 100))
        block.position = CGPoint(x: 150, y: 200)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.affectedByGravity = false
        self.addChild(block)
        
        block2 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 100))
        block2.position = CGPoint(x: 150, y: 400)
        block2.physicsBody = SKPhysicsBody(rectangleOf: block2.size)
        block2.physicsBody?.affectedByGravity = false
        block2.physicsBody?.isDynamic = false
        self.addChild(block2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let destination = touches.first!.location(in: self)
        let distance = hypot(player.position.x - destination.x, player.position.y - destination.y)
        let duration = distance / playerSpeed
        player.removeAction(forKey: "move")
        player.run(SKAction.move(to: destination, duration: TimeInterval(duration)), withKey: "move")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
