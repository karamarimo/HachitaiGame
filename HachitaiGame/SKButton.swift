//
//  SKButton.swift
//  HachitaiGame
//
//  Created by admin on 2016/09/24.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import GameKit

class SKButton: SKSpriteNode {
    
    private var callback: ((Void)->Void)?
    
    func setCallback(_ cb: @escaping (Void) -> Void) {
        self.isUserInteractionEnabled = true
        callback = cb
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            if self.frame.contains(touch.location(in: self.scene!)) {
                callback?()
//                print("\(self.name) pressed")
            }
        }
    }
    
}
