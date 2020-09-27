//
//  DataManager.swift
//  My wishlist
//
//  Created by Дмитрий on 27.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    
    internal func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Group Data
    
    func getColorToGroupName(withGroup wishGroup: String?) -> UIColor {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            for group in result as [NSManagedObject] {
                if (group.value(forKey: "groupName") as! String?) == wishGroup {
                    let color = group.value(forKey: "color") as! String
                    
                    let finishColor = GroupsViewCell().transformStringTo(color: color)
                    return finishColor
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return .black
    }
    
    // MARK: - All data
    
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
    }
    
}
