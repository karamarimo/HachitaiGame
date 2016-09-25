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
        super.init(texture: texture, color: UIColor.blue, size: rect.size)
        self.position = rect.origin
        self.physicsBody = SKPhysicsBody(rectangleOf: rect.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
