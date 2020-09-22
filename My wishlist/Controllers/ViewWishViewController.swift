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
    
    var mainVC = MainViewController()
    
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
        
        wishImage.image = UIImage(data: currentWish.wishImage!)
        wishTitleLabel.text = currentWish.wishTitle
        wishPriceLabel.text = String(currentWish.wishPrice)
        wishCommentLabel.text = currentWish.wishComment
        //wishLinkLabel.text = currentWish.wishLink
        wishGroupLabel.text = currentWish.wishGroup
        wishPriceCurrencyLabel.text = currentWish.currency
        wishLinkText.text = currentWish.wishLink
        switchCurrency(currency: currentWish.currency)
        
        wishLinkText.textContainerInset = UIEdgeInsets.zero
        wishLinkText.textContainer.lineFragmentPadding = 0

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
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * 0.84))
            } else if wishPriceCurrencyLabel.text == "₽" {
                wishPriceLabel.text = String(currentWish.wishPrice * 78)
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        case "€":
            
            if wishPriceCurrencyLabel.text == "$" {
                wishPriceLabel.text = String(Int(Double(currentWish.wishPrice) * 1.18))
            } else if wishPriceCurrencyLabel.text == "₽" {
                wishPriceLabel.text = String(currentWish.wishPrice * 88)
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        case "₽":
            
            if wishPriceCurrencyLabel.text == "$" {
                wishPriceLabel.text = String(currentWish.wishPrice / 78)
            } else if wishPriceCurrencyLabel.text == "€" {
                wishPriceLabel.text = String(currentWish.wishPrice / 88)
            } else {
                wishPriceLabel.text = String(currentWish.wishPrice)
            }
            
        default:
            print("wrong")
        }
        
    }
    
    
    // MARK: - Table view data source
    
    
    // MARK: - Core Data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editWish" {
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.viewControllers.first as! NewWishViewController
            targetController.currentWishInNew = currentWish
        }
    }
}



