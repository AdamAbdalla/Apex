//
//  StoreViewController.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/11/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit
import CoreData

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    
    static let colors: [UIColor] = [UIColor(named: "purple")!, UIColor(named: "blue")!, UIColor(named: "teal")!, UIColor(named: "green")!, UIColor(named: "orange")!, UIColor(named: "red")!, UIColor(named: "pink")!, UIColor(named: "black")!]
    //var available: [Bool] = [true, false, false, false, false, false, false, false]
    var coinCount: NSManagedObject? = nil
    //var currentColor = UIColor(named: "purple")!
    //var selected = 0
    var colorState: NSManagedObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let coins = coinCount?.value(forKeyPath: "count") as? Int {
            if coins == 1 {
                coinsLabel.text = String(coins) + " COIN"
            } else {
                coinsLabel.text = String(coins) + " COINS"
            }
        } else {
            coinsLabel.text = "0 COINS"
        }
        colorTableView.delegate = self
        colorTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateColors()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "storeToHomeSegue", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? HomeViewController {
            dest.coinCount = coinCount
            dest.colorState = colorState
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return StoreViewController.colors.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAvailable(index: indexPath.section) {
            setColor(index: indexPath.section)
            updateColors()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colors = StoreViewController.colors
        if let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as? ColorTableViewCell {
            let color = colors[indexPath.section]
            for label in cell.gradientStack.arrangedSubviews {
                label.backgroundColor = color
                label.layer.cornerRadius = label.frame.width / 2
            }
            cell.useButton.layer.cornerRadius = cell.useButton.frame.width / 2
            cell.gradientView.backgroundColor = UIColor(named: "background")
            cell.gradientView.layer.cornerRadius = cell.gradientView.frame.height / 2
            if (isAvailable(index: indexPath.section)) {
                let checkmark = UIImage(named: "checkmark")!
                if indexPath.section == currentColor() {
                    cell.useButton.backgroundColor = UIColor(named: "background")
                    cell.useButton.tintColor = colors[currentColor()]
                } else {
                    cell.useButton.backgroundColor = colors[currentColor()]
                    cell.useButton.tintColor = UIColor(named: "background")
                }
                cell.useButton.setImage(checkmark, for: .normal)
            } else {
                cell.useButton.backgroundColor = colors[currentColor()]
            }
            cell.selectionStyle = .none
            cell.useButton.tag = indexPath.section;
            cell.useButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func updateColors() {
        let colors = StoreViewController.colors
        coinsLabel.textColor = colors[currentColor()]
        homeButton.backgroundColor = colors[currentColor()]
        let checkmark = UIImage(named: "checkmark")!
        let cells = colorTableView.visibleCells
        if cells.count > 0 {
            for i in 0 ... cells.count - 1 {
                if let colorCell = cells[i] as? ColorTableViewCell {
                    if i == currentColor() {
                        colorCell.useButton.backgroundColor = UIColor(named: "background")!
                        colorCell.useButton.setImage(checkmark, for: .normal)
                        colorCell.useButton.tintColor = colors[currentColor()]
                    } else if isAvailable(index: i) {
                        colorCell.useButton.backgroundColor = colors[currentColor()]
                        colorCell.useButton.setImage(checkmark, for: .normal)
                        colorCell.useButton.tintColor = UIColor(named: "background")!
                    } else {
                        colorCell.useButton.backgroundColor = colors[currentColor()]
                    }
                }
            }
        }
    }
    
    @objc func connected(sender: UIButton) {
        let id = sender.tag
        print("pressed" + String(id))
        if isAvailable(index: id) {
            setColor(index: id)
            updateColors()
            return
        }
        if let coins = coinCount!.value(forKeyPath: "count") as? Int {
            if coins >= 100 {
                addCoins(-100)
                buyColor(index: id)
                updateColors()
                if coins - 100 == 1 {
                    coinsLabel.text = String(coins - 100) + " COIN"
                } else {
                    coinsLabel.text = String(coins - 100) + " COINS"
                }
            }
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
    
    func isAvailable(index: Int) -> Bool {
        return colorState?.value(forKeyPath: "color" + String(index)) as! Bool
    }
    
    func setColor(index: Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ColorState", in: managedContext)!
        let newstate = NSManagedObject(entity: entity, insertInto: managedContext)
        newstate.setValue(index, forKeyPath: "current")
        for i in 0 ... 7 {
            newstate.setValue(colorState?.value(forKey: "color" + String(i)), forKeyPath: "color" + String(i))
        }
        do {
            try managedContext.save()
            colorState = newstate
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func buyColor(index: Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ColorState", in: managedContext)!
        let newstate = NSManagedObject(entity: entity, insertInto: managedContext)
        newstate.setValue(index, forKeyPath: "current")
        for i in 0 ... 7 {
            if i != index {
                newstate.setValue(colorState?.value(forKey: "color" + String(i)), forKeyPath: "color" + String(i))
            } else {
                newstate.setValue(true, forKey: "color" + String(index))
            }
        }
        do {
            try managedContext.save()
            colorState = newstate
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
