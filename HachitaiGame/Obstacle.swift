//
//  Obstacle.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class ObstacleSpriteNode: SKSpriteNode {
    
    required init(rect: CGRect, texture: SKTexture?) {
        super.init(texture: texture, color: UIColor.white, size: CGSize(width: 20, height: 20))
        self.centerRect = CGRect(x: 1.0/3, y: 1.0/3, width: 1.0/3, height: 1.0/3)
        self.position = rect.origin
        self.xScale = rect.width / self.size.width
        self.yScale = rect.height / self.size.height
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = CollisionBitmask.wall
        self.physicsBody?.collisionBitMask = CollisionBitmask.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ObstaclePathNode: SKShapeNode {
//    required init(path: CGPath) {
//        super.init(path: path)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
