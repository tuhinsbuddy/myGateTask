//
//  ContactDetailsMainTableViewCell.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 16/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ContactDetailsMainTableViewCell: UITableViewCell {

    @IBOutlet weak var userContactDetailsMainProfileImageView: UIImageView!
    @IBOutlet weak var userContactDetailsStackView: UIStackView!
    @IBOutlet weak var userContactDetailsNameLbl: UILabel!
    @IBOutlet weak var userContactDetailsNumberLbl: UILabel!
    @IBOutlet weak var userContactDetailsCellSelectedSuperView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        userContactDetailsCellSelectedSuperView.layer.cornerRadius = 10
        userContactDetailsCellSelectedSuperView.clipsToBounds = true
        userContactDetailsMainProfileImageView.layer.cornerRadius = userContactDetailsMainProfileImageView.frame.size.height / 2
        userContactDetailsMainProfileImageView.clipsToBounds = true
    }
    
}
