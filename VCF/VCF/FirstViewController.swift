//
//  FirstViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 12/30/18.
//  Copyright © 2018 Timothy Younkin. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    //MARK: Properties
    
    var announcements = [Announcement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view one loaded")
        parseJSON(){ yes in
            // and here you get the "returned" value from the asynchronous task
            print(yes)
            print ("ran parseJson")
            print(self.announcements)
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

