//
//  enemy.swift
//  
//
//  Created by KamedaKei on 2016/09/25.
//
//

import Foundation
import GameKit




class CharacterNode: SKSpriteNode{

    required init(){
        super.init(texture: nil, color: UIColor.red, size: CGSize(width:20, height:20))
     
        let directionIndicator = Utility.makeArrow()
        self.addChild(directionIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
