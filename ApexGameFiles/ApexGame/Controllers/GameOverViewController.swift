//
//  GameOverViewController.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/11/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit
import CoreData

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    
    var score: Int = 0
    var timed = false
    var highscore: NSManagedObject? = nil
    var coinCount: NSManagedObject? = nil
    var colorState: NSManagedObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = StoreViewController.colors[currentColor()];
        scoreLabel.textColor = color
        coinsLabel.textColor = color
        highScoreLabel.textColor = color
        gameOverLabel.textColor = color
        playAgainButton.backgroundColor = color
        homeButton.backgroundColor = color
        storeButton.backgroundColor = color
        
        highScoreLabel.text = "HIGH SCORE: " + String(highscore!.value(forKey: "score") as! Int)
        scoreLabel.text = String(score)
        if (timed) {
            coinsLabel.text = "+ " + String(score / 10) + " COIN"
            if score / 10 != 1 {
                coinsLabel.text! += "S"
            }
            addCoins(score / 10)
        } else {
            coinsLabel.text = ""
        }
    }
    
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        print("here")
        performSegue(withIdentifier: "gameOverToGameSegue", sender: view)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "gameOverToHomeSegue", sender: view)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "gameOverToStoreSegue", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? StoreViewController {
            dest.coinCount = coinCount
            dest.colorState = colorState
        }
        if let dest = segue.destination as? HomeViewController {
            dest.coinCount = coinCount
            dest.colorState = colorState
        }
        if let dest = segue.destination as? GameViewController {
            print("here")
            dest.coinCount = coinCount
            dest.colorState = colorState
        }
    }
    
    func save(newScore: Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HighScore", in: managedContext)!
        let high = NSManagedObject(entity: entity, insertInto: managedContext)
        high.setValue(newScore, forKeyPath: "score")
        do {
            try managedContext.save()
            highscore = high
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addCoins(_ c : Int) {
        var coins = c
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoinCount", in: managedContext)!
        let count = NSManagedObject(entity: entity, insertInto: managedContext)
        if let cCount = coinCount, let count = cCount.value(forKeyPath: "count") as? Int{
            coins += count
        }
        count.setValue(coins, forKeyPath: "count")
        do {
            try managedContext.save()
            coinCount = count
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
