//
//  ViewWishViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class ViewWishViewController: UITableViewController, UITextFieldDelegate {

    var currentWish: Wish!
    var wishes: [Wish] = []
    var numberOfCurrentCurrency: Int = 0
    
    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishTitleLabel: UILabel!
    @IBOutlet weak var wishGroupLabel: UILabel!
    @IBOutlet weak var wishPriceLabel: UILabel!
    @IBOutlet weak var wishLinkLabel: UILabel!
    @IBOutlet weak var wishCommentLabel: UILabel!
    @IBOutlet weak var wishPriceCurrencyLabel: UILabel!
    @IBOutlet weak var wishLinkText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScreen()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func currencyButtonTapped(_ sender: Any) {
        
        if numberOfCurrentCurrency == 2 {
            numberOfCurrentCurrency = 0
        } else {
            numberOfCurrentCurrency += 1
        }
        
        switch numberOfCurrentCurrency {
        case 0:
            wishPriceCurrencyLabel.text = "$"
            
        case 1:
            wishPriceCurrencyLabel.text = "€"
            
        case 2:
            wishPriceCurrencyLabel.text = "₽"
        default: print("smth went wrong")
        }
        
        switch currentWish.currency {
        case "$":
            
            if wishPriceCurrencyLabel.text == "€" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * (CurrencySettings.dollarInEuros ?? 0.85)))
            } else if wishPriceCurrencyLabel.text == "₽" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * (CurrencySettings.dollarInRubles ?? 77)))
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        case "€":
            
            if wishPriceCurrencyLabel.text == "$" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * (CurrencySettings.euroInDollars ?? 1.17)))
            } else if wishPriceCurrencyLabel.text == "₽" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * (CurrencySettings.euroInRubles ?? 88)))
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        case "₽":
            
            if wishPriceCurrencyLabel.text == "$" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) / (CurrencySettings.dollarInRubles ?? 77)))
            } else if wishPriceCurrencyLabel.text == "€" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) / (CurrencySettings.euroInRubles ?? 88)))
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        default:
            print("wrong")
        }
        
    }
 
    // MARK: - Set the Screen
    
    private func setScreen() {
        wishImage.image = UIImage(data: currentWish.wishImage!)
        wishTitleLabel.text = currentWish.wishTitle
        wishPriceLabel.text = String(currentWish.wishPrice)
        wishCommentLabel.text = currentWish.wishComment
        wishGroupLabel.text = currentWish.wishGroup
        wishPriceCurrencyLabel.text = currentWish.currency
        wishLinkText.text = currentWish.wishLink
        switchCurrency(currency: currentWish.currency)
        
        wishLinkText.textContainerInset = UIEdgeInsets.zero
        wishLinkText.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: - Currency switcher
    
    func switchCurrency(currency: String?){
        switch currency {
        case "$":
            numberOfCurrentCurrency = 0
        case "€":
            numberOfCurrentCurrency = 1
        case "₽":
            numberOfCurrentCurrency = 2
        default:
            print("wrong")
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editWish" {
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.viewControllers.first as! NewWishViewController
            targetController.currentWishInNew = currentWish
        }
    }
}



