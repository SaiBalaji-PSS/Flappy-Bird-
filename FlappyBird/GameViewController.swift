//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Sai Balaji on 24/02/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var backgroundimg: UIImageView!
    @IBOutlet weak var logoimg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playbtn.layer.borderWidth = 2
        playbtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        playbtn.backgroundColor = #colorLiteral(red: 0.01415322814, green: 0.8708636165, blue: 0.03914334252, alpha: 1)
        playbtn.layer.cornerRadius = 10
       
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    @IBAction func playBtn(_ sender: Any) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                playbtn.isHidden = true
                logoimg.isHidden = true
                backgroundimg.isHidden = true
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
