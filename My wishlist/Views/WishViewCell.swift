//
//  WishViewCell.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit

class WishViewCell: UITableViewCell {

    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishTitleLabel: UILabel!
    @IBOutlet weak var wishPriceLabel: UILabel!
    @IBOutlet weak var wishGroupLabel: UILabel!
    @IBOutlet weak var wishPriceCurrency: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
