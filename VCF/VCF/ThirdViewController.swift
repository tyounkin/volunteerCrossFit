//
//  ThirdViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 1/3/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import UIKit
import os.log

class ThirdViewController: UITableViewController {
    
    var wods = [WOD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedWODs = loadWODs() {
            wods += savedWODs
        }
        else{
            loadSampleWods()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wods.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "wodTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? wodTableViewCell  else {
                fatalError("The dequeued cell is not an instance of wodTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let wod = wods[indexPath.row]
//        let dfs = DateFormatter()
//        dfs.dateFormat = "yy/MM/dd"
        cell.dateLabel.text = wod.date
        cell.wodNameLabel.text = wod.name
        cell.scoreLabel.text = String(format:"%.2f", wod.score)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            wods.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addWod":
            os_log("Adding a new wod.", log: OSLog.default, type: .debug)
            
        case "viewWodSegue":
            guard let wodDetailViewController = segue.destination as? wodViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedWodCell = sender as? wodTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedWodCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedWod = wods[indexPath.row]
            wodDetailViewController.wod = selectedWod
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToWODList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? wodViewController, let wod = sourceViewController.wod {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                wods[selectedIndexPath.row] = wod
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: wods.count, section: 0)
                
                wods.append(wod)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveWODs()
        }
    }
    
    private func loadSampleWods() {
        
        guard let Wod1 = WOD(name: "Fran", date: "19/01/01", score: 1.0) else {
            fatalError("Unable to instantiate Wod1")
        }
        
        guard let Wod2 = WOD(name: "Diane", date: "19/01/02", score: 2.0) else {
            fatalError("Unable to instantiate Wod2")
        }
        
        guard let Wod3 = WOD(name: "Jackie", date: "19/01/03", score: 3.0) else {
            fatalError("Unable to instantiate Wod2")
        }
        
        wods += [Wod1, Wod2, Wod3]
        
    }
    
    private func saveWODs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(wods, toFile: WOD.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("WODs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save WODs...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadWODs() -> [WOD]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: WOD.ArchiveURL.path) as? [WOD]
    }

}
