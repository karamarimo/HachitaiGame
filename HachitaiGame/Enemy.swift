//
//  enemy.swift
//  
//
//  Created by KamedaKei on 2016/09/25.
//
//

import Foundation
import GameKit
import SKTUtils



class EnemyNode: SKSpriteNode {
    
    
    let fieldOfView = CGFloat(M_PI / 5)
    let visionRange: CGFloat = 200.0
    
    let lookAroundAnimation = SKAction.repeatForever(SKAction.sequence([
        SKAction.rotate(byAngle: CGFloat(M_PI_4), duration: 0.5),
        SKAction.wait(forDuration: 1.0),
        SKAction.rotate(byAngle: -CGFloat(M_PI_4), duration: 0.5),
        SKAction.wait(forDuration: 1.0)
        ]))

    required init(){
        super.init(texture: nil, color: UIColor.red, size: CGSize(width:20, height:20))
        
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
        self.addChild(visionIndicator)
        
        self.run(lookAroundAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // TODO: decode properties
        
        super.init(coder: aDecoder)
    }

    public func detect(target: SKSpriteNode) -> Bool {
        let vec = CGPointSubtract(target.position, self.position)
        
        // check distance
        if CGPointLength(vec) > visionRange {
            return false
        }
        
        // check angle
        let angle = fabs( (CGPointToAngle(vec) - self.zRotation).remainder(dividingBy: (CGFloat)(M_PI * 2)) )
        if angle > self.fieldOfView {
            return false
        }
        
        // check obstacles
        var unobstructed = true
        self.scene?.physicsWorld.enumerateBodies(alongRayStart: self.position, end: target.position, using: { (body: SKPhysicsBody, point: CGPoint, normal: CGVector, stop: UnsafeMutablePointer<ObjCBool>) in
            if let node = body.node {
                if node !== self && node !== target {
                    unobstructed = false
                    stop.pointee = true
                }
            }
        })
        return unobstructed
    }

}
