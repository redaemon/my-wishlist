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
    var groupEntity: Group!
    let groupsViewCell = GroupsViewCell()
    let wishTableCell = WishViewCell()
    let dataManager = DataManager()
    
    @IBOutlet weak var wishTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wishTable.delegate = self
        self.wishTable.dataSource = self
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.wishTable.setEditing(!wishTable.isEditing, animated: true)
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
        cell.wishGroupLabel.text = wish.wishGroup
        cell.wishGroupLabel.textColor = dataManager.getColorToGroupName(withGroup: wish.wishGroup)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = dataManager.getContext()
        let wish: Wish! = wishes[indexPath.row]
        
        let deleteWish = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            context.delete(wish)
            self.wishes.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        deleteWish.image = UIImage(systemName: "trash")
        
        let editWish = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let editViewController = storyboard.instantiateViewController(withIdentifier: "newWish") as! NewWishViewController
            let navController = UINavigationController(rootViewController: editViewController)
            
            editViewController.currentWishInNew = wish
            self.present(navController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        editWish.backgroundColor = .systemGreen
        editWish.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteWish, editWish])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Number of wishes: \(wishes.count)"
    }
    
    // MARK: - Navigation
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = dataManager.getContext()
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
