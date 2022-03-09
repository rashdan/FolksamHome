//
//  UserTableViewCell.swift
//  Home
//
//  Created by Johan Torell on 2021-02-25.
//

import Foundation
import FolksamCommon
import UIKit

class UserCell: UITableViewCell {
    @IBOutlet var streetLabel: UILabel!
    @IBOutlet var postalCodeLabel: UILabel!
    @IBOutlet var subRegionLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

//        restaurantImageView.layer.masksToBounds = true
//        restaurantImageView.layer.cornerRadius = 20
//
//        informationView.layer.masksToBounds = true
//        informationView.layer.cornerRadius = 12
    }

    func configure(user: ParentUser) {
        streetLabel.text = user.street
        postalCodeLabel.text = user.postalcode
        subRegionLabel.text = user.subregion
        telephoneLabel.text = user.telephone
        mailLabel.text = user.email
    }
}
