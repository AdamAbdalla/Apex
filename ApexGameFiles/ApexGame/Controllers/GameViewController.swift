//
//  GameViewController.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/11/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lifeIndicator: UIStackView!
    @IBOutlet weak var quitButton: UIButton!
    
    var scene: GameScene!
    var timed = true
    var coinCount: NSManagedObject? = nil
    var colorState: NSManagedObject? = nil
    //var currentColor = UIColor(named: "purple")!
    //var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = StoreViewController.colors[currentColor()]
        scoreLabel.textColor = color
        timeLabel.textColor = color
        quitButton.backgroundColor = color
        for life in lifeIndicator.arrangedSubviews {
            life.backgroundColor = color
        }
        
        let skView = gameView!
        scene = GameScene(size: skView.frame.size)
        scene.scaleMode = .resizeFill
        scene.currentColor = color
        scene.viewController = self
        scene.timeLabel = timeLabel
        scene.scoreLabel = scoreLabel
        if !timed {
            timeLabel.isHidden = true
            lifeIndicator.isHidden = true
        } else {
            scene.timed = true
        }
        scoreLabel.text = "0"
        skView.ignoresSiblingOrder = true
        scene.lifeIndicators = lifeIndicator.arrangedSubviews as? [UILabel]
        skView.presentScene(scene)
    }
    
    @IBAction func quitButtonPressed(_ sender: Any) {
        scene.endGame()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameOverViewController {
            dest.score = scene.score
            dest.timed = timed
            dest.coinCount = coinCount
            dest.colorState = colorState
            
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HighScore")
            do {
                let x = try managedContext.fetch(fetchRequest)
                if x.count > 0 {
                    dest.highscore = x[x.count - 1]
                }
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            if dest.highscore == nil || scene.score > dest.highscore!.value(forKeyPath: "score") as! Int {
                    dest.save(newScore: scene.score)
            }
        }
    }
    
    func currentColor() -> Int {
        return colorState?.value(forKeyPath: "current") as! Int
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
