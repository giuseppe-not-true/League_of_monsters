//
//  GameScene.swift
//  Open Map Test
//
//  Created by alessandro on 14/02/22.
//
import SpriteKit
import SwiftUI
import GameplayKit



class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate {
    var sound = ""
    var left = false
    var changedirr = false
    var changedirl = false
    var player = Player()
    var enemies = [Enemy]()
    var spawnPoints : [CGPoint] = [CGPoint(x: -850.0, y: 430.0), CGPoint(x: -542.0, y: -223.0), CGPoint(x: 87.0, y: -477.0), CGPoint(x: 120.0, y: -697.0), CGPoint(x: 920.0, y: -550.0), CGPoint(x: 562.0, y: 406.0)]
    var scoreNode = SKLabelNode()
    var targetToDestroy : [SKNode?] = []
    lazy var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        js.zPosition = 10
        return js
    }()
    let rubbleArray = ["rubble-1", "rubble-2", "rubble-3"]
    
    let velocityMultiplier: CGFloat = 0.05
    
    @Published var score = 0
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        for child in self.children {
            
            if let isSpriteNode = child as? SKSpriteNode {

                switch isSpriteNode.name {
                    
                case "Small_building":
                    
                    isSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: isSpriteNode.size.width, height: isSpriteNode.size.height / 2), center: CGPoint(x: 0.5, y: 0))
                    isSpriteNode.physicsBody!.restitution = 0.0
                    isSpriteNode.physicsBody!.friction = 0.0
                    isSpriteNode.physicsBody!.linearDamping = 0.0
                    isSpriteNode.physicsBody!.angularDamping = 0.0
                    isSpriteNode.physicsBody!.mass = 1.14400005340576
                    isSpriteNode.physicsBody!.allowsRotation = false
                    isSpriteNode.physicsBody!.affectedByGravity = false
                    isSpriteNode.physicsBody!.pinned = true
                    isSpriteNode.physicsBody!.isDynamic = false
                    isSpriteNode.zPosition = 10
                    
                case "Medium_building":
                    isSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: isSpriteNode.size.width, height: isSpriteNode.size.height / 3.3), center: CGPoint(x: 0.5, y: 25))
                    isSpriteNode.physicsBody!.restitution = 0.0
                    isSpriteNode.physicsBody!.friction = 0.0
                    isSpriteNode.physicsBody!.linearDamping = 0.0
                    isSpriteNode.physicsBody!.angularDamping = 0.0
                    isSpriteNode.physicsBody!.mass = 1.14400005340576
                    isSpriteNode.physicsBody!.allowsRotation = false
                    isSpriteNode.physicsBody!.affectedByGravity = false
                    isSpriteNode.physicsBody!.pinned = true
                    isSpriteNode.physicsBody!.isDynamic = false
                    isSpriteNode.zPosition = 10
                    
                case "Big_building":
                    isSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: isSpriteNode.size.width, height: isSpriteNode.size.height / 4), center: CGPoint(x: 0.5, y: 0))
                    isSpriteNode.physicsBody!.restitution = 0.0
                    isSpriteNode.physicsBody!.friction = 0.0
                    isSpriteNode.physicsBody!.linearDamping = 0.0
                    isSpriteNode.physicsBody!.angularDamping = 0.0
                    isSpriteNode.physicsBody!.mass = 1.14400005340576
                    isSpriteNode.physicsBody!.allowsRotation = false
                    isSpriteNode.physicsBody!.affectedByGravity = false
                    isSpriteNode.physicsBody!.pinned = true
                    isSpriteNode.physicsBody!.isDynamic = false
                    isSpriteNode.zPosition = 10
                    
                default:
                    print("Error.")
                }
            }
        }
        
        
        createPlayer()
        cameraSetup()
        setupJoystick()
        player.idleRight()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            if self.enemies.count < 5 {
                self.randomEnemy()
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
     
        for child in self.children {

            if let isSpriteNode = child as? SKSpriteNode {
                if isSpriteNode.name != "player" && isSpriteNode.name != "stones" && isSpriteNode.name != "enemy"{
                    if isSpriteNode.position.y > player.position.y{
                        isSpriteNode.zPosition=9
                    }
                    else{
                        isSpriteNode.zPosition = 11
                    }
                }

            }
        }
        
        

        
        if(analogJoystick.data.velocity.x>0 && (analogJoystick.ismoving==false)){
            player.walkRight()
            left=false
            analogJoystick.ismoving.toggle()
            changedirr=true
        }
        else if(analogJoystick.data.velocity.x<0 && (analogJoystick.ismoving==false)){
            player.walkLeft()
            left=true
            analogJoystick.ismoving.toggle()
            changedirl=true
        }
        else if(analogJoystick.data.velocity.x == 0 && (analogJoystick.ismoving==true)){
            if(left==false){
                player.idleRight()
            }
            else{
                player.idleLeft()
            }
            analogJoystick.ismoving.toggle()
        }
        
        if(changedirr){
            if(analogJoystick.data.velocity.x<0){
                analogJoystick.ismoving=false
                changedirr=false
            }
        }
        else if(changedirl){
            if(analogJoystick.data.velocity.x>0){
                analogJoystick.ismoving=false
                changedirl=false
            }
        }
        
        
        for enemy in enemies {
            let location = player.position
            
            //Aim
            let dx = (location.x) - enemy.position.x
            let dy = (location.y) - enemy.position.y
            let angle = atan2(dy, dx)


            //Seek
            let velocityX =  cos(angle) * 1.5
            let velocityY =  sin(angle) * 1.5
            
            
            
            if enemy.position.x <= location.x && abs(dy)<50{
                enemy.texture = SKTexture(imageNamed: "polizia_profilo_dx")
                enemy.size.height = 24
                enemy.size.width = 48

            }
            else if enemy.position.x > location.x && abs(dy)<50 {
                enemy.texture = SKTexture(imageNamed: "polizia_profilo_sx")
                enemy.size.height = 24
                enemy.size.width = 48

            }
            else if enemy.position.y <= location.y  && abs(dx)<50{
                enemy.texture = SKTexture(imageNamed: "polizia_fronte_su")
                enemy.size.height = 48
                enemy.size.width = 24

            }
            else if enemy.position.y > location.y && abs(dx)<50{
                enemy.texture = SKTexture(imageNamed: "polizia_fronte_giu")
                enemy.size.height = 48
                enemy.size.width = 24

            }
            
            
            if abs(dx) > CGFloat.random(in: 140...160) {
                enemy.position.x += velocityX
            }
            if abs(dy) > CGFloat.random(in: 140...160) {
                enemy.position.y += velocityY
            }
            
            if abs(dx) < CGFloat.random(in: 90...110) {
                enemy.position.x -= velocityX
            }
            if abs(dy) < CGFloat.random(in: 90...110) {
                enemy.position.y -= velocityY
            }
            if abs(dx) < CGFloat.random(in: 150...160) {
                if enemy.shots {
                    self.spawnBullet(enemy: enemy)
                    enemy.shots=false
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...4)){
                        enemy.shots=true
                    }
                }
            }
            
            
        }
        
    }
    
    func spawnBullet(enemy:SKSpriteNode){
        let Bullet = SKShapeNode(circleOfRadius: 5)

        Bullet.name = "bullet"
        Bullet.zPosition = 11
        
        Bullet.position = CGPoint(x: enemy.position.x + 10, y: enemy.position.y + 10)
        
        Bullet.strokeColor = .yellow
        Bullet.glowWidth = 5.0
        Bullet.fillColor = .yellow
        
        let action = SKAction.move(to: self.player.position, duration: 3)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        
//        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        Bullet.physicsBody!.contactTestBitMask = Bullet.physicsBody!.collisionBitMask
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
    }
    
    func cameraSetup(){
        guard let camera = camera else{return}
        let zeroDistance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(zeroDistance, to: player)
        camera.constraints = [playerConstraint]
        camera.zPosition = 15
    }
    
    func createPlayer() {
        player.name = "player"
        player.zPosition = 10
        player.size.width = 150.0
        player.size.height = 150.0
//        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2.6)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width/1.5, height: player.size.height), center: CGPoint(x: player.position.x, y: player.position.y))
        player.physicsBody!.restitution = 0.0
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.affectedByGravity = false
        player.position = CGPoint(x: -250, y: -270)
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        addChild(player)
        player.idleRight()
    }
    
    func randomEnemy(){
        let enemy = Enemy(imageNamed: "polizia_profilo_dx")
        
        enemy.name = "enemy"
        enemy.size.height = 48
        enemy.size.width = 96
        enemy.setScale(0.5)
        //enemy.zPosition = 9
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.allowsRotation = false
        enemy.physicsBody!.restitution = 0.0
        enemy.physicsBody!.allowsRotation = false
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.friction = 0.0
        enemy.physicsBody!.isDynamic = true
        
        enemy.position = spawnPoints[Int.random(in: 0...spawnPoints.count-1)]
        
        enemy.physicsBody!.contactTestBitMask = enemy.physicsBody!.collisionBitMask
        enemy.zPosition = 8
        enemies.append(enemy)
        addChild(enemy)
        
    }
    
    func setupJoystick() {
        camera?.addChild(analogJoystick)
        analogJoystick.trackingHandler = { [unowned self] data in
            self.player.position = CGPoint(x: self.player.position.x + (data.velocity.x * self.velocityMultiplier),
                                           y: self.player.position.y + (data.velocity.y * self.velocityMultiplier))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name != "transenne_collider" && nodeA.name != "transenne" && nodeA.name != "smoke" && nodeA.name != "spark" && nodeA.name != "fire" && nodeA.name != "rubble" && nodeA.name != "stones" && nodeA.name != "bullet"{
            if nodeB.name == "player" {
                targetToDestroy.append(nodeA)
            }
        }
        if nodeA.name == "bullet" {
            if nodeB.name == "player" {
                self.player.health -= 5
                
                if let particles = SKEmitterNode(fileNamed: "spark.sks") {
                    particles.name = "spark"
                    particles.position = nodeB.position
                    particles.particleSize.width = 10.0
                    particles.particleSize.height = 10.0
                    particles.zPosition = 7

                    addChild(particles)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            particles.particleScale = 0.01
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        particles.run(SKAction.fadeOut(withDuration: 0.5))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            particles.removeFromParent()
                        }
                    }
                }
                
                nodeA.removeFromParent()
            }
        }
        if nodeB.name == "bullet" {
            if nodeA.name == "player" {
                self.player.health -= 5
                
                if let particles = SKEmitterNode(fileNamed: "spark.sks") {
                    particles.name = "spark"
                    particles.position = nodeB.position
                    particles.particleSize.width = 10.0
                    particles.particleSize.height = 10.0
                    particles.zPosition = 7

                    addChild(particles)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            particles.particleScale = 0.01
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        particles.run(SKAction.fadeOut(withDuration: 0.5))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            particles.removeFromParent()
                        }
                    }
                }
                
                nodeB.removeFromParent()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if ((nodeA.name == "Medium_building" || nodeA.name == "Big_building" || nodeA.name == "Small_building" && nodeB.name == "player") || (nodeB.name == "Medium_building" || nodeB.name == "Big_building" || nodeB.name == "Small_building" && nodeA.name == "player")){
            if !(targetToDestroy.isEmpty) {
                targetToDestroy.remove(at: targetToDestroy.count-1)
            }
        }
    }
    
    func changeTexture (_ target: SKSpriteNode) {
        
        sound = "destroyedSound.mp3"
        playSound()
        if target.name == "Medium_building" {
            targetToDestroy.remove(at: targetToDestroy.count-1)
            target.physicsBody = nil
            target.name = "stones"
            target.zPosition = 6
            score += 2

            if let particles = SKEmitterNode(fileNamed: "smoke.sks") {
                particles.name = "smoke"
                particles.position = target.position
                particles.particleSize.width = target.size.width
                particles.particleSize.height = target.size.height
                particles.zPosition = 7

                addChild(particles)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        particles.particleScale = 0.01
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    particles.run(SKAction.fadeOut(withDuration: 0.5))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        particles.removeFromParent()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                target.texture = SKTexture(imageNamed: self.rubbleArray[Int.random(in: 0...2)])
                target.size.height = 80
                target.size.width = 80
            }
        } else if target.name == "Big_building" {
            targetToDestroy.remove(at: targetToDestroy.count-1)
            target.physicsBody = nil
            target.name = "stones"
            target.zPosition = 6
            score += 3

            if let particles = SKEmitterNode(fileNamed: "smoke.sks") {
                particles.name = "smoke"
                particles.position = target.position
                particles.particleSize.width = target.size.width
                particles.particleSize.height = target.size.height
                particles.zPosition = 7

                addChild(particles)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        particles.particleScale = 0.01
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    particles.run(SKAction.fadeOut(withDuration: 0.5))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        particles.removeFromParent()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                target.texture = SKTexture(imageNamed: self.rubbleArray[Int.random(in: 0...2)])
                target.size.height = 100
                target.size.width = 100
            }
        } else if target.name == "Small_building" {
            targetToDestroy.remove(at: targetToDestroy.count-1)
            target.physicsBody = nil
            target.name = "stones"
            target.zPosition = 6
            score += 1

            if let particles = SKEmitterNode(fileNamed: "smoke.sks") {
                particles.name = "smoke"
                particles.position = target.position
                particles.particleSize.width = target.size.width
                particles.particleSize.height = target.size.height
                particles.zPosition = 7

                addChild(particles)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        particles.particleScale = 0.01
                    
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    particles.run(SKAction.fadeOut(withDuration: 0.5))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        particles.removeFromParent()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                target.texture = SKTexture(imageNamed: self.rubbleArray[Int.random(in: 0...2)])
                target.size.height = 60
                target.size.width = 60
            }
        } else if target.name == "enemy" {
            let targetEnemy = target as! Enemy
            targetEnemy.physicsBody?.isDynamic = false
            targetEnemy.isTouching = true
            targetToDestroy.remove(at: targetToDestroy.count-1)
            enemies.remove(at: enemies.firstIndex(of: targetEnemy)!)
            targetEnemy.physicsBody = nil
            targetEnemy.name = "stones"
            targetEnemy.zPosition = 6
            score += 2

            if let particles = SKEmitterNode(fileNamed: "fire.sks") {
                particles.name = "fire"
                particles.position = targetEnemy.position
                particles.particleSize.width = targetEnemy.size.width
                particles.particleSize.height = targetEnemy.size.height * 2
                particles.zPosition = 7
                addChild(particles)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    particles.run(SKAction.fadeOut(withDuration: 0.5))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        particles.removeFromParent()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    targetEnemy.removeFromParent()
                }
            }
       }
    }
    
    
    func playSound(){
        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        sound = ""
    }
    
}
