//
//  NewWishViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit

class NewWishViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var wishTitleField: UITextField!
    @IBOutlet weak var wishImageInsert: UIImageView!
    @IBOutlet weak var wishGroupField: UITextField!
    @IBOutlet weak var wishLinkField: UITextField!
    @IBOutlet weak var wishCommentField: UITextField!
    @IBOutlet weak var wishPriceField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func currencyButtonTapped(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source



}
