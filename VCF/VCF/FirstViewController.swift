//
//  FirstViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 12/30/18.
//  Copyright © 2018 Timothy Younkin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("view one loaded")
        parseJSON()
        print ("ran parseJson")
    }


    func parseJSON() {
        let url = URL(string: "https://raw.githubusercontent.com/tyounkin/volunteerCrossFit/master/high_scores.json")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            print(content)
            let json = try? JSONSerialization.jsonObject(with: content, options: [])
            if let array = json as? [Any] {
//                if let firstObject = array.first {
//                    // access individual object in array
//                }
                
                for object in array {
                    let thisObj = object as! Dictionary<String, AnyObject>
                    print(object)
                    print(thisObj["firstName"]!)
                }
            }
            
//            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                print("Not containing JSON")
//                return
//            }
//            print(json)
//            var thisArray = [String]()
//           if let array = json["firstName"] as? [String] {
//               thisArray = array
//            }
//
//            print(thisArray)
            
        }
        
        task.resume()
        
    }
}

