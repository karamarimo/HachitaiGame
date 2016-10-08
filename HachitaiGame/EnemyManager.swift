//
//  EnemyController.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/30.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit
import SKTUtils
import SwiftEventBus

class EnemyManager {
    public var enemies: [EnemyNode] = []
    public var player: PlayerNode?
    
    required init(enemies: [EnemyNode], player: PlayerNode) {
        self.enemies = enemies
        self.player = player
        
    }
    
    
    public func update() {
        SwiftEventBus.post(GameConst.Enemy.updateVision)
        SwiftEventBus.post(GameConst.Enemy.detect, sender: player)
    }
}
