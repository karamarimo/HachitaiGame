//
//  enemy.swift
//  
//
//  Created by KamedaKei on 2016/09/25.
//
//

import Foundation
import GameKit




class Charactor: SKSpriteNode{

    required init(){
        super.init(texture: nil, color: UIColor.red, size: CGSize(width:20, height:20))
     
        let directionIndicator = SKShapeNode(path: directionPath)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeArrow() -> CGPath {
        let directionPath = CGMutablePath()
        
        directionPath.addLine(to: CGPoint(x: 0, y: 20)
    }
}

class Player {
    
}
