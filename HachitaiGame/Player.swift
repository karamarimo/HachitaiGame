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
        super.init(texture: nil, color: UIColor.green, size: CGSize(width: 20, height: 20))
        self.addChild(Utility.makeArrow())
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
