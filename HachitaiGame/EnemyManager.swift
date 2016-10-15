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
    var enemies: [EnemyNode] = []
    var player: PlayerNode?
    var obstacles: [ObstacleSpriteNode] = []
    
    required init(enemies: [EnemyNode], player: PlayerNode, obstacles: [ObstacleSpriteNode]) {
        self.enemies = enemies
        self.player = player
        self.obstacles = obstacles
    }
    
    
    public func update() {
        SwiftEventBus.post(GameConst.Enemy.updateVision, sender: obstacles as AnyObject)
        SwiftEventBus.post(GameConst.Enemy.detect, sender: player)
    }
}
