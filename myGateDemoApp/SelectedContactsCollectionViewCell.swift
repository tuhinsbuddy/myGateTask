//
//  SelectedContactsCollectionViewCell.swift
//  myGateDemoApp
//
//  Created by Tuhin Samui on 17/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class SelectedContactsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedContactsMainImageViewSuperView: UIView!
    @IBOutlet weak var selectedContactsNameLbl: UILabel!
    @IBOutlet weak var selectedContactsMainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.selectedContactsMainImageViewSuperView.layer.cornerRadius = self.selectedContactsMainImageViewSuperView.layer.frame.size.height / 2
        self.selectedContactsNameLbl.textColor = UIColor.black
        self.selectedContactsNameLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14)!

    }
    
}
