//
//  GroupsViewCell.swift
//  My wishlist
//
//  Created by Дмитрий on 22.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit

class GroupsViewCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var colorPoint: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func transformStringTo(color: String) -> UIColor {
        switch color {
        case "Red":
            return .systemRed
        case "Orange":
            return .systemOrange
        case "Yellow":
            return .systemYellow
        case "Green":
            return .systemGreen
        case "Blue":
            return .systemBlue
        case "Sky":
            return .systemTeal
        case "Purple":
            return .systemPurple
        case "Pink":
            return .init(red: 251.0/255.0, green: 159.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        case "Indigo":
            return .systemIndigo
        case "Brown":
            return .brown
        case "White":
            return .systemFill
        case "Black":
            return .black
        default:
            return .black
        }
    }

}
