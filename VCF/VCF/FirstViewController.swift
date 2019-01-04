//
//  FirstViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 12/30/18.
//  Copyright © 2018 Timothy Younkin. All rights reserved.
//

import UIKit
import os.log

class FirstViewController: UITableViewController {
    //MARK: Properties
    
    var announcements = [Announcement]()
    var announcementsTotal = [Announcement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view one loaded")
        let group = DispatchGroup()
        group.enter()
        parseJSON(){ yes in
            // and here you get the "returned" value from the asynchronous task
            print(yes)
            print ("ran parseJson")
            print(self.announcements)
            for each in self.announcements{
                self.announcementsTotal.append(each)
            }
            group.leave()
        }
        group.wait()
        print("the end", self.announcementsTotal)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcementsTotal.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AnnouncementTableViewCell"

       guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? AnnouncementTableViewCell  else {
                fatalError("The dequeued cell is not an instance of AnnouncementTableViewCell.")
        }

        // Fetches the appropriate meal for the data source layout.
       let announcement = announcementsTotal[indexPath.row]

        cell.dateLabel.text = announcement.name
        cell.shortDescriptionLabel.text = String(format:"%.2f", announcement.score)


        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
//
//
//
//    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           // Delete the row from the data source
            announcementsTotal.remove(at: indexPath.row)
            //saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "showAnnouncement":
            guard let announcementDetailViewController = segue.destination as? AnnouncementViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedAnnouncementCell = sender as? AnnouncementTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedAnnouncementCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedAnnouncement = announcementsTotal[indexPath.row]
            announcementDetailViewController.announcement = selectedAnnouncement
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
        
        
    func parseJSON(completion:  @escaping (String) -> ()){
        let url = URL(string: "https://raw.githubusercontent.com/tyounkin/volunteerCrossFit/master/high_scores.json")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            
            if let content = data {
                print(content)
                let json = try? JSONSerialization.jsonObject(with: content, options: [])
                if let array = json as? [AnyObject] {
                    
                    for object in array {
                        let thisName = object["firstName"] as! String
                        let thisScore = object["score"] as! Float
                        print(object)
                        print(thisName)
                        print(thisScore)
                        
                        let thisAnnouncement = Announcement(name: thisName, score: thisScore)
                        print(thisAnnouncement!.name)
                        print(thisAnnouncement!.score)
                        self.announcements.append(thisAnnouncement!)
                        print(self.announcements)
                    }
                }
                let yes = "Yes"
                completion(yes)
            }
            else {
                print("not returning data")
                return
            }
            
            
        }

        task.resume()
    }
    
}

