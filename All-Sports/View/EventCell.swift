//
//  EventCell.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 05/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//self.backgroundColor = UIColor.lightGray
        // Configure the view for the selected state
    }

}
