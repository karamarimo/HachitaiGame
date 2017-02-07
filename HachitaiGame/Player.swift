//
//  Player.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class PlayerNode: SKSpriteNode {
    required init() {
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "player2")), color: UIColor.white ,size: CGSize(width: 20, height: 20))

        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0
        self.physicsBody?.categoryBitMask = CollisionBitmask.player
        self.physicsBody?.collisionBitMask = CollisionBitmask.wall
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
