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
    var currentWishInNew: Wish!
    
    var numberOfCurrentCurrency: Int = 1
    
    var groupsForPicker: [String] = []
    var groups: [Group] = []
    
    var selectedGroup: String?
    var imageIsChanged = false
    
    let dataManager = DataManager()
    
    var userFromCollectionView = false
    
    @IBOutlet weak var wishTitleField: UITextField!
    @IBOutlet weak var wishImageInsert: UIImageView!
    @IBOutlet weak var wishGroupField: UITextField!
    @IBOutlet weak var wishLinkField: UITextField!
    @IBOutlet weak var wishCommentField: UITextField!
    @IBOutlet weak var wishPriceField: UITextField!
    @IBOutlet weak var wishPriceCurrencyLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        
        editWish()
        
        wishTitleField.delegate = self
        wishCommentField.delegate = self
        wishLinkField.delegate = self
        
        self.hideKeyboardWhenTappedOutside()
        
        wishTitleField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let wishTitle = wishTitleField.text
        let wishGroup = wishGroupField.text
        let wishLink = wishLinkField.text
        let wishComment = wishCommentField.text
        let wishPrice = Int(wishPriceField.text!)
        let wishCurrency = wishPriceCurrencyLabel.text
        let wishImage = wishImageInsert.image?.pngData()
        
        if currentWishInNew != nil {
            saveWish(withTitle: wishTitle, withImage: wishImage, withGroup: wishGroup ?? "Default", withLink: wishLink, withComment: wishComment, withPrice: wishPrice!, withCurrency: wishPriceCurrencyLabel.text)
        } else {
            saveWish(withTitle: wishTitle, withImage: wishImage, withGroup: selectedGroup ?? "Default", withLink: wishLink, withComment: wishComment, withPrice: wishPrice ?? 1, withCurrency: wishCurrency)
        }
        
        dismiss(animated: true)
    }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
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
    
    // MARK: - Edit View

    private func editWish() {
        
        if currentWishInNew != nil {
            self.title = "Edit wish"
            
            wishImageInsert.image = UIImage(data: currentWishInNew.wishImage!)
            wishTitleField.text = currentWishInNew.wishTitle
            wishPriceField.text = String(currentWishInNew.wishPrice)
            wishCommentField.text = currentWishInNew.wishComment
            wishLinkField.text = currentWishInNew.wishLink
            wishGroupField.text = currentWishInNew.wishGroup
            wishPriceCurrencyLabel.text = currentWishInNew.currency
        }
    }
    
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
    
    private func saveWish(withTitle wishTitle: String?, withImage wishImage: Data?, withGroup wishGroup: String?, withLink wishLink: String?, withComment wishComment: String?, withPrice wishPrice: Int, withCurrency wishPriceCurrency: String?) {
        
        let context = dataManager.getContext()
        
        if currentWishInNew == nil {
            
            guard let entityWish = NSEntityDescription.entity(forEntityName: "Wish", in: context) else { return }
            let wishObject = Wish(entity: entityWish, insertInto: context)
            wishObject.wishTitle = wishTitle
            wishObject.wishImage = wishImage
            wishObject.wishGroup = wishGroup
            wishObject.wishLink = wishLink
            wishObject.wishComment = wishComment
            wishObject.wishPrice = Int32(wishPrice)
            wishObject.currency = wishPriceCurrency
        } else {
            currentWishInNew.wishTitle = wishTitle
            currentWishInNew.wishImage = wishImage
            currentWishInNew.wishGroup = wishGroup
            currentWishInNew.wishLink = wishLink
            currentWishInNew.wishComment = wishComment
            currentWishInNew.wishPrice = Int32(wishPrice)
            currentWishInNew.currency = wishPriceCurrency
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if userFromCollectionView == true {
            self.performSegue(withIdentifier: "saveWishAndReloadCollection", sender: self)
        } else {
           self.performSegue(withIdentifier: "saveWishAndReload", sender: self)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOfCurrentCurrency = 1
        
        let context = dataManager.getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                groupsForPicker.append((data.value(forKey: "groupName") as! String))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Exit from keyboard by "Done" button
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

// MARK: - Picker View

extension NewWishViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        groupsForPicker.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupsForPicker[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = groupsForPicker[row]
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

// MARK: - Image Picker

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

// MARK: - Hide Keyboard functions and Save button settings

extension NewWishViewController {
    
    func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewWishViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldChanged() {
        
        if wishTitleField.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
}
