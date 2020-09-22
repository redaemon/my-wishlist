//
//  NewGroupViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 22.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UITableViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    let colorArray: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Sky", "Purple", "Pink", "Indigo", "Brown", "White"]
    
    var newGroup: Group!
    var groups: [Group] = []
    var selectedColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.dataSource = self
        colorPickerView.delegate = self
        
        groupNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setEditScreen()
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let groupTitle = self.groupNameTextField.text
        let groupColor = selectedColor
        
        if newGroup != nil {
            self.saveGroup(withTitle: groupNameTextField.text, withColor: selectedColor)
        } else {
            self.saveGroup(withTitle: groupTitle, withColor: groupColor)
        }
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Core Data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveGroup(withTitle groupTitle: String?, withColor groupColor: String?) {
        let context = getContext()
        
        if newGroup == nil {
            guard let entityGroup = NSEntityDescription.entity(forEntityName: "Group", in: context) else { return }
             
             let groupObject = Group(entity: entityGroup, insertInto: context)
             groupObject.groupName = groupTitle
             groupObject.color = groupColor
        } else {
            newGroup.groupName = groupTitle
            newGroup.color = groupColor
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "saveGroupAndReload", sender: self)
    }
    
    func setEditScreen() {
        
        if newGroup != nil {
            self.title = "Edit group"
            
            groupNameTextField.text = newGroup.groupName
            colorPickerView.selectRow(colorArray.firstIndex(of: newGroup.color ?? "Red") ?? 0, inComponent: 0, animated: true)
        } else {
            saveButton.isEnabled = false
        }
    }

    // MARK: - Table view data source

    
    
}

extension NewGroupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colorArray[row]
    }
}

extension NewGroupViewController {
    
    @objc private func textFieldChanged() {
        
        if groupNameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
