//
//  nearbyTableViewCell.swift
//  Magicpass
//
//  Created by Noah Marriott on 8/23/15.
//  Copyright (c) 2015 Noah Marriott. All rights reserved.
//

import UIKit

class nearbyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var city: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
