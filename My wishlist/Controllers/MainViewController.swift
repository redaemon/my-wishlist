//
//  ViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wish: Wish!
    var wishes: [Wish] = []
    var groupsForSection: [String] = ["Longterm", "Nearest", "Future"]
    let wishTableCell = WishViewCell()
    
    @IBOutlet weak var wishTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wishTable.delegate = self
        self.wishTable.dataSource = self
    
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath) as! WishViewCell
        
        let wish = wishes[indexPath.row]
        let image = UIImage(data: wish.wishImage!)
        let currency = (wish.currency)!
        cell.wishImage.image = image
        cell.wishTitleLabel.text = wish.wishTitle
        cell.wishPriceLabel.text = "\(String(wish.wishPrice)) \(currency)"
        cell.wishCommentLabel.text = wish.wishGroup
        
        if wish.wishGroup == "Nearest" {
            cell.wishCommentLabel.textColor = .systemGreen
        } else if wish.wishGroup == "Longterm" {
            cell.wishCommentLabel.textColor = .systemOrange
        } else if wish.wishGroup == "Future" {
            cell.wishCommentLabel.textColor = .systemRed
        }
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWish" {
            guard let indexPath = wishTable.indexPathForSelectedRow else { return }
            let wish: Wish
            
            wish = wishes[indexPath.row]
            
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.topViewController as! ViewWishViewController
            targetController.currentWish = wish
        }
    }
    
    // MARK: - Core Data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("here we go")
        let context = getContext()
        let fetchRequest: NSFetchRequest<Wish> = Wish.fetchRequest()
        let sort = NSSortDescriptor(key: "wishGroup", ascending: false)
        fetchRequest.sortDescriptors = [sort]

        do {
            wishes = try context.fetch(fetchRequest)

        } catch let error as NSError {
            print(error.localizedDescription)
        }

        
        self.wishTable.reloadData()
        
    }
    

}
