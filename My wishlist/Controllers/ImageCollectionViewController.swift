//
//  ImageCollectionViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 21.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class ImageCollectionViewController: UICollectionViewController {

    var wish: Wish!
    var wishes: [Wish] = []
    
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    
    let dataManager = DataManager()
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func unwindToCollectionView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wishes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! WishCollectionViewCell
    
        let wish = wishes[indexPath.item]
        
        let image = UIImage(data: wish.wishImage!)
        cell.imageView.image = image
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        cell.imageView.heightAnchor.constraint(equalToConstant: CGFloat(widthPerItem)).isActive = true
        cell.imageView.widthAnchor.constraint(equalToConstant: CGFloat(widthPerItem)).isActive = true
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWish" {
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.imageCollectionView.indexPath(for: cell)
            let wish: Wish
            
            wish = wishes[indexPath!.row]
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.topViewController as! ViewWishViewController
            targetController.currentWish = wish
        }
        
        if segue.identifier == "newWishFromCollection" {
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.topViewController as! NewWishViewController
            targetController.userFromCollectionView = true
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
        
        self.imageCollectionView.reloadData()
    }
    
}

// MARK: - Edit Image Cells

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

}
