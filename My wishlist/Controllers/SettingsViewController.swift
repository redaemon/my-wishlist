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

    @IBOutlet weak var dollarInRublesLabel: UILabel!
    @IBOutlet weak var euroInRublesLabel: UILabel!
    @IBOutlet weak var dollarInEurosLabel: UILabel!
    @IBOutlet weak var euroInDollarsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dollarInRublesLabel.text = String(CurrencySettings.dollarInRubles!)
        self.euroInRublesLabel.text = String(CurrencySettings.euroInRubles!)
        self.dollarInEurosLabel.text = String(CurrencySettings.dollarInEuros!)
        self.euroInDollarsLabel.text = String(CurrencySettings.euroInDollars!)
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
    
    func showAlert(message: String, deleteText: String) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: deleteText, style: .destructive) { [weak self] (action:UIAlertAction) in
            switch deleteText {
            case "Delete the wishes": self?.deleteData(entity: "Wish")
            case "Delete the groups": self?.deleteData(entity: "Group")
            case "Delete all data":
                self?.deleteData(entity: "Wish")
                self?.deleteData(entity: "Group")
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
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func deleteData(entity name:String) {
        
        let context = getContext()
        let freq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: freq)
        
        do {
            try context.execute(deleteRequest)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        viewWillAppear(true)
    }

}
