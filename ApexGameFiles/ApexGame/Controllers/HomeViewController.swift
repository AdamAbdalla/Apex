//
//  HomeViewController.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/11/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var coinCount: NSManagedObject? = nil
    var colorState: NSManagedObject? = nil
    let logos = [UIImage(named: "ApexLogo"), UIImage(named:"BlueLogo"), UIImage(named: "TealLogo"), UIImage(named: "GreenLogo"), UIImage(named: "OrangeLogo"), UIImage(named: "RedLogo"), UIImage(named: "PinkLogo"), UIImage(named: "BlackLogo")]
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var logoView: UIImageView!
    
    override func viewDidLoad() {
        let colors = StoreViewController.colors
        super.viewDidLoad()
        loadCoins()
        loadColor()
        playButton.backgroundColor = colors[currentColor()]
        storeButton.backgroundColor = colors[currentColor()]
        logoView.image = logos[currentColor()]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func timedButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToGameSegue", sender: view)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToStoreSegue", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? StoreViewController {
            dest.coinCount = coinCount
            dest.colorState = colorState
            
        }
        if let dest = segue.destination as? GameViewController {
            dest.coinCount = coinCount
            dest.colorState = colorState
        }
    }
    
    func loadColor() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ColorState")
        do {
            let x = try managedContext.fetch(fetchRequest)
            if x.count > 0 {
                colorState = x[x.count - 1]
            } else {
                initColorState()
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func initColorState() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ColorState", in: managedContext)!
        let colors = NSManagedObject(entity: entity, insertInto: managedContext)
        colors.setValue(0, forKeyPath: "current")
        colors.setValue(true, forKeyPath: "color0")
        for i in 1 ... 7 {
            colors.setValue(false, forKeyPath: "color" + String(i))
        }
        do {
            try managedContext.save()
            colorState = colors
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadCoins() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoinCount")
        do {
            let x = try managedContext.fetch(fetchRequest)
            if x.count > 0 {
                coinCount = x[x.count - 1]
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
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
