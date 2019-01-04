//
//  AnnouncementViewController.swift
//  VCF
//
//  Created by Timothy Younkin on 1/3/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import UIKit


class AnnouncementViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    
    var announcement: Announcement?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let announcement = announcement {
            //navigationItem.title = meal.name
            dateLabel.text = announcement.name
            shortDescriptionLabel.text = String(format:"%.2f", announcement.score)
            
        }
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
