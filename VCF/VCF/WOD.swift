//
//  WOD.swift
//  VCF
//
//  Created by Timothy Younkin on 1/5/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import Foundation
import UIKit
import os.log

class WOD: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var date: String?
    var score: Float
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("wods")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let date = "date"
        static let score = "score"
    }
    
    //MARK: Initialization
    
    init?(name: String, date:String?, score:Float) {
        self.name = name
        self.date = date
        self.score = score
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(score, forKey: PropertyKey.score)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
//        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else {
//            os_log("Unable to decode the date for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yy/MM/dd"
//        let date = formatter.date(from: dateString)!
        guard let score = aDecoder.decodeObject(forKey: PropertyKey.score) as? Float else {
            os_log("Unable to decode the score for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
//        // Because photo is an optional property of Meal, just use conditional cast.
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String
        
//        let score = aDecoder.decodeObject(forKey: PropertyKey.score) as! Float
//
//        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, date: date!, score: score)
    }
    
}
