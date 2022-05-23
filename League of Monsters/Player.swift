//
//  Player.swift
//  Open Map Test
//
//  Created by alessandro on 17/02/22.
//

import SpriteKit

class Player: SKSpriteNode{
    
    var health = 100.0
    
    let idleAnimationRightTextures = [SKTexture(imageNamed: "doge1"), SKTexture(imageNamed: "doge2"), SKTexture(imageNamed: "doge3"), SKTexture(imageNamed: "doge4"), SKTexture(imageNamed: "doge5"), SKTexture(imageNamed: "doge6"), SKTexture(imageNamed: "doge7"), SKTexture(imageNamed: "doge8")]
    
    let idleAnimationLeftTextures = [SKTexture(imageNamed: "doge1L"), SKTexture(imageNamed: "doge2L"), SKTexture(imageNamed: "doge3L"), SKTexture(imageNamed: "doge4L"), SKTexture(imageNamed: "doge5L"), SKTexture(imageNamed: "doge6L"), SKTexture(imageNamed: "doge7L"), SKTexture(imageNamed: "doge8L")]
    
    let walkAnimationRightTextures = [SKTexture(imageNamed: "doge-walk1"), SKTexture(imageNamed: "doge-walk2"), SKTexture(imageNamed: "doge-walk3"), SKTexture(imageNamed: "doge-walk4"), SKTexture(imageNamed: "doge-walk5"), SKTexture(imageNamed: "doge-walk6"), SKTexture(imageNamed: "doge-walk7"), SKTexture(imageNamed: "doge-walk8"), SKTexture(imageNamed: "doge-walk9")]
    
    let walkAnimationLeftTextures = [SKTexture(imageNamed: "doge-walk1L"), SKTexture(imageNamed: "doge-walk2L"), SKTexture(imageNamed: "doge-walk3L"), SKTexture(imageNamed: "doge-walk4L"), SKTexture(imageNamed: "doge-walk5L"), SKTexture(imageNamed: "doge-walk6L"), SKTexture(imageNamed: "doge-walk7L"), SKTexture(imageNamed: "doge-walk8L"), SKTexture(imageNamed: "doge-walk9L")]
    
    let bonkAnimationLeftTextures = [SKTexture(imageNamed: "doge-bonk-left1"), SKTexture(imageNamed: "doge-bonk-left2"), SKTexture(imageNamed: "doge-bonk-left3"), SKTexture(imageNamed: "doge-bonk-left4")]
    
    let bonkAnimationRightTextures = [SKTexture(imageNamed: "doge-bonk-right1"), SKTexture(imageNamed: "doge-bonk-right2"), SKTexture(imageNamed: "doge-bonk-right3"), SKTexture(imageNamed: "doge-bonk-right4")]
    
    func idleRight () {
        let idleAnimationRight = SKAction.animate(with: [idleAnimationRightTextures[0], idleAnimationRightTextures[1], idleAnimationRightTextures[2], idleAnimationRightTextures[3], idleAnimationRightTextures[4], idleAnimationRightTextures[5], idleAnimationRightTextures[6]], timePerFrame: 0.15)
        let idleRight = SKAction.repeatForever(idleAnimationRight)
        self.run(idleRight)
    }

    func idleLeft () {
        let idleAnimationLeft = SKAction.animate(with: [idleAnimationLeftTextures[0], idleAnimationLeftTextures[1], idleAnimationLeftTextures[2], idleAnimationLeftTextures[3], idleAnimationLeftTextures[4], idleAnimationLeftTextures[5], idleAnimationLeftTextures[6]], timePerFrame: 0.15)
        let idleLeft = SKAction.repeatForever(idleAnimationLeft)
        self.run(idleLeft)
    }
    
    func walkRight () {
        let walkAnimationRight = SKAction.animate(with: [walkAnimationRightTextures[0], walkAnimationRightTextures[1], walkAnimationRightTextures[2], walkAnimationRightTextures[3], walkAnimationRightTextures[4], walkAnimationRightTextures[5], walkAnimationRightTextures[6], walkAnimationRightTextures[7]], timePerFrame: 0.2)
        let walkRight = SKAction.repeatForever(walkAnimationRight)

        self.run(walkRight)
    }
    
    
    func walkLeft () {
        let walkAnimationLeft = SKAction.animate(with: [walkAnimationLeftTextures[0], walkAnimationLeftTextures[1], walkAnimationLeftTextures[2], walkAnimationLeftTextures[3], walkAnimationLeftTextures[4], walkAnimationLeftTextures[5], walkAnimationLeftTextures[6], walkAnimationLeftTextures[7]], timePerFrame: 0.2)
        let walkLeft = SKAction.repeatForever(walkAnimationLeft)
        self.run(walkLeft)
    }
    
    func bonkLeft () {
        let bonkAnimationLeft = SKAction.animate(with: [bonkAnimationLeftTextures[0], bonkAnimationLeftTextures[1], bonkAnimationLeftTextures[2], bonkAnimationLeftTextures[3]], timePerFrame: 0.1)
        let bonkLeft = SKAction.repeat(bonkAnimationLeft, count: 1)
        self.run(bonkLeft)
    }
    
    func bonkRight () {
        let bonkAnimationRight = SKAction.animate(with: [bonkAnimationRightTextures[0], bonkAnimationRightTextures[1], bonkAnimationRightTextures[2], bonkAnimationRightTextures[3]], timePerFrame: 0.1)
        let bonkRight = SKAction.repeat(bonkAnimationRight, count: 1)
        self.run(bonkRight)
    }
    
    
}
