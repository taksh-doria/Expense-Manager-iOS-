//
//  CustomTableViewCell.swift
//  Expense Manager
//
//  Created by Taksh on 28/08/20.
//  Copyright © 2020 Taksh Doria. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var priceimage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
