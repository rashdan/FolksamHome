//
//  PolicyCell.swift
//  Home
//
//  Created by Johan Torell on 2021-02-25.
//

import Foundation
import FolksamCommon
import UIKit

class PolicyCell: UITableViewCell {
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(policy: Policy) {
        productLabel.text = policy.product
        for (i, label) in stackView.arrangedSubviews.enumerated() {
            if let label = label as? UILabel {
                if let elements = policy.elements, elements.indices.contains(i) {
                    label.text = elements[i]
                }
            }
        }
    }
}
