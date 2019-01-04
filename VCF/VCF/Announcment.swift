//
//  Announcment.swift
//  VCF
//
//  Created by Timothy Younkin on 1/2/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import Foundation
import UIKit

class Announcement: NSObject {
    
    //MARK: Properties
    
    var name: String
    var score: Float
    
    init?(name: String, score:Float) {
        self.name = name
        self.score = score
    }
    
}
