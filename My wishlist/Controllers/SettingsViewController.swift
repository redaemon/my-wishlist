//
//  SettingsViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 22.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {

    let dataManager = DataManager()
    
    @IBOutlet weak var dollarInRublesLabel: UILabel!
    @IBOutlet weak var euroInRublesLabel: UILabel!
    @IBOutlet weak var dollarInEurosLabel: UILabel!
    @IBOutlet weak var euroInDollarsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrenciesLabels()
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all wishes?", deleteText: "Delete the wishes")
        } else if indexPath.row == 1 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all groups?", deleteText: "Delete the groups")
            
        } else if indexPath.row == 2 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all data?", deleteText: "Delete all data")
        }
    }
    
    // MARK: - Exchange rates from User Defaults
    
    func setCurrenciesLabels() {
        self.dollarInRublesLabel.text = String(CurrencySettings.dollarInRubles ?? 77)
        self.euroInRublesLabel.text = String(CurrencySettings.euroInRubles ?? 88)
        self.dollarInEurosLabel.text = String(CurrencySettings.dollarInEuros ?? 0.85)
        self.euroInDollarsLabel.text = String(CurrencySettings.euroInDollars ?? 1.17)
    }
    
    // MARK: - Deleting
    
    func showAlert(message: String, deleteText: String) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: deleteText, style: .destructive) { [weak self] (action:UIAlertAction) in
            switch deleteText {
            case "Delete the wishes":
                self?.dataManager.deleteData(entity: "Wish")
                self?.viewWillAppear(true)
            case "Delete the groups":
                self?.dataManager.deleteData(entity: "Group")
                self?.viewWillAppear(true)
            case "Delete all data":
                self?.dataManager.deleteData(entity: "Wish")
                self?.dataManager.deleteData(entity: "Group")
                self?.viewWillAppear(true)
            default: print("wrong")
            };
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(delete)
        deleteAlert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(deleteAlert, animated: true)
        }
    }

}
