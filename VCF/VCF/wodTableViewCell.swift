//
//  wodTableViewCell.swift
//  VCF
//
//  Created by Timothy Younkin on 1/5/19.
//  Copyright © 2019 Timothy Younkin. All rights reserved.
//

import UIKit

class wodTableViewCell: UITableViewCell {

    @IBOutlet weak var wodNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
