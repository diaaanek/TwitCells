//
//  TwitCell.swift
//  CandidApp
//
//  Created by Diane Korongy on 5/03/2018.
//  Copyright © 2018 Diane Korongy. All rights reserved.
//

import UIKit

class TwitCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var twitMSG: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
