//
//  GameScene.swift
//  OrangeTree
//
//  Created by Rinni Swift on 9/19/18.
//  Copyright © 2018 Rinni Swift. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        // connect game objects
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the location of the touch on screen
        let touches = touches.first!
        let location = touches.location(in: self)
        
        // check if touch is on the orange tree
        if atPoint(location).name == "tree" {
            // create orange at the touched location on the tree
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            // store the location of the touch
            touchStart = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get location of the touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // update location of orange on the orane tree
        orange?.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // get difference of start and end point of drag distance
        let dx = touchStart.x - location.x
        let dy = touchStart.y - location.y
        let vector = CGVector(dx: dx, dy: dy)
        
        // set orange dynamic and apply vector as impulse
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
    }
}
