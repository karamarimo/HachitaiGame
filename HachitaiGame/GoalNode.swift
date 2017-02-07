//
//  Goal.swift
//  HachitaiGame
//
//  Created by admin on 2016/11/06.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class GoalNode: SKNode {
    required init(position: CGPoint, size: CGSize) {
        super.init()
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = CollisionBitmask.goal
        self.physicsBody?.contactTestBitMask = CollisionBitmask.player
        self.physicsBody?.collisionBitMask = .allZeros
        
        // for debug
        let indicator = SKSpriteNode(color: UIColor.green, size: size)
        self.addChild(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
