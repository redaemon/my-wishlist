//
//  NewWishViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class NewWishViewController: UITableViewController, UITextFieldDelegate {

    var wishes: [Wish] = []
    var numberOfCurrentCurrency: Int = 1
    var groups: [String] = ["Nearest", "Longterm", "Future"]
    var selectedGroup: String?
    var imageIsChanged = false
    
    @IBOutlet weak var wishTitleField: UITextField!
    @IBOutlet weak var wishImageInsert: UIImageView!
    @IBOutlet weak var wishGroupField: UITextField!
    @IBOutlet weak var wishLinkField: UITextField!
    @IBOutlet weak var wishCommentField: UITextField!
    @IBOutlet weak var wishPriceField: UITextField!
    @IBOutlet weak var wishPriceCurrencyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPickerView()
        
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func currencyButtonTapped(_ sender: Any) {
        
        switch numberOfCurrentCurrency {
        case 0:
            wishPriceCurrencyLabel.text = "$"
            numberOfCurrentCurrency += 1
            
        case 1:
            wishPriceCurrencyLabel.text = "€"
            numberOfCurrentCurrency += 1
            
        case 2:
            wishPriceCurrencyLabel.text = "₽"
            numberOfCurrentCurrency = 0
        default: print("smth went wrong")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        numberOfCurrentCurrency = 1
    }
    
    
    // MARK: - Table view data source


    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo-1")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera",
                                       style: .default) {_ in
                                        self.chooseImagePicker(source: .camera)
                        }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) {_ in
                                        self.chooseImagePicker(source: .photoLibrary)
                       }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    // MARK: - Core data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveWish(withTitle wishTitle: String?, withImage wishImage: Data?, withGroup wishGroup: String?, withLink wishLink: String?, withComment wishComment: String?, withPrice wishPrice: Int, withCurrency wishPriceCurrency: String?) {
        
        let context = getContext()
        
        guard let entityTask = NSEntityDescription.entity(forEntityName: "Wish", in: context) else { return }
        
        let wishObject = Wish(entity: entityTask, insertInto: context)
        
        wishObject.wishTitle = wishTitle
        wishObject.wishImage = wishImage
        wishObject.wishGroup = wishGroup
        wishObject.wishLink = wishLink
        wishObject.wishComment = wishComment
        wishObject.wishPrice = Int32(wishPrice)
        wishObject.currency = wishPriceCurrency
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "saveWishAndReload", sender: self)

    }

}

extension NewWishViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        groups.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = groups[row]
        wishGroupField.text = selectedGroup
    }

    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        wishGroupField.inputView = pickerView

        dismissPickerView()
        action()
    }

    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       wishGroupField.inputAccessoryView = toolBar
    }

    @objc func action() {
          view.endEditing(true)
    }

}

extension NewWishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source:UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
         
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        wishImageInsert.image = info[.editedImage] as? UIImage
        wishImageInsert.contentMode = .scaleAspectFill
        wishImageInsert.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
    
}
