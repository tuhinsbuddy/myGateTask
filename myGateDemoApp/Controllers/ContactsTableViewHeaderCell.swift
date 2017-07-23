//
//  ContactsTableViewHeaderCell.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 19/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ContactsTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var sectionMainSuperView: UIView!
    @IBOutlet weak var sectionMainHeaderLbl: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
