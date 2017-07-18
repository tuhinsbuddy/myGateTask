//
//  SelectedContactsCollectionViewCell.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 17/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class SelectedContactsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedContactDetailsMainStackView: UIStackView!
    @IBOutlet weak var selectedContactsNameLbl: UILabel!
    @IBOutlet weak var selectedContactsMainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
