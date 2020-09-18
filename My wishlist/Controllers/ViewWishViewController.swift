//
//  ViewWishViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit

class ViewWishViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishTitleLabel: UILabel!
    @IBOutlet weak var wishGroupLabel: UILabel!
    @IBOutlet weak var wishPriceLabel: UILabel!
    @IBOutlet weak var wishLinkLabel: UILabel!
    @IBOutlet weak var wishCommentLabel: UILabel!
    @IBOutlet weak var wishPriceCurrencyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func currencyButtonTapped(_ sender: Any) {
    }
    

    // MARK: - Table view data source


}
