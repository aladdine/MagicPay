//
//  wooUITableViewCell.swift
//  Magicpass
//
//  Created by Noah Marriott on 8/23/15.
//  Copyright (c) 2015 Noah Marriott. All rights reserved.
//

import UIKit

class wooUITableViewCell: UITableViewCell {

    @IBOutlet weak var miNum: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
