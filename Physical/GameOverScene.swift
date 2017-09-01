import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Game over!"
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
