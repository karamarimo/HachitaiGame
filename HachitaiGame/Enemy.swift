//
//  enemy.swift
//  
//
//  Created by KamedaKei on 2016/09/25.
//
//

import Foundation
import GameKit




class EnemyNode: SKSpriteNode{
    
    
    let fieldOfView = CGFloat(M_PI / 5)
    let visionRange: CGFloat = 100.0
    
    let lookAroundAnimation = SKAction.repeatForever(SKAction.sequence([
        SKAction.rotate(byAngle: CGFloat(M_PI_4), duration: 0.5),
        SKAction.wait(forDuration: 1.0),
        SKAction.rotate(byAngle: -CGFloat(M_PI_4), duration: 0.5),
        SKAction.wait(forDuration: 1.0)
        ]))

    required init(){
        super.init(texture: nil, color: UIColor.red, size: CGSize(width:20, height:20))
        
        self.zPosition = 1.0
        
        let directionIndicator = Utility.makeArrow()
        self.addChild(directionIndicator)
        
        let fovPath = CGMutablePath()
        fovPath.move(to: CGPoint(x: 0, y: 0))
        fovPath.addArc(center: CGPoint.zero, radius: visionRange, startAngle: -fieldOfView, endAngle: fieldOfView, clockwise: false)
        fovPath.addLine(to: CGPoint.zero)
        
        let visionIndicator = SKShapeNode(path: fovPath)
        visionIndicator.strokeColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4)
        visionIndicator.lineWidth = 2.0
        visionIndicator.fillColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.4)
        visionIndicator.zPosition = 0.0
        self.addChild(visionIndicator)
        
        self.run(lookAroundAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
