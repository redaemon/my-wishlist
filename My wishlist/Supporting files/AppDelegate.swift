//
//  AppDelegate.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setActualCurrenciesToLabels()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "My_wishlist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getCurrencies(baseCurrency: String, exchangeToCurrency: String, handler:@escaping (Double?)-> Void){
        let url = NSURL(string: "https://api.exchangeratesapi.io/latest?base=\(baseCurrency)&symbols=\(exchangeToCurrency)")
        var exchangeRate: Double = 0
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                exchangeRate = Double(((string.components(separatedBy: ",")[0]).components(separatedBy: ":")[2]).components(separatedBy: "}")[0]) ?? 81
                handler(exchangeRate)
            }
        }
        task.resume()
        
    }
    
    func setActualCurrenciesToLabels(){
        
//        getCurrencies(baseCurrency: "EUR", exchangeToCurrency: "RUB") { (rate) in
//            if var rate = rate{
//                DispatchQueue.main.async {
//                    rate = (rate * 100).rounded() / 100
//                    CurrencySettings.euroInRubles = rate
//
//                }
//            }
//        }
//
//        getCurrencies(baseCurrency: "USD", exchangeToCurrency: "RUB") { (rate) in
//            if var rate = rate{
//                DispatchQueue.main.async {
//                    rate = (rate * 100).rounded() / 100
//                    CurrencySettings.dollarInRubles = rate
//                }
//            }
//        }
//
//        getCurrencies(baseCurrency: "USD", exchangeToCurrency: "EUR") { (rate) in
//            if var rate = rate{
//                DispatchQueue.main.async {
//                    rate = (rate * 100).rounded() / 100
//                    CurrencySettings.dollarInEuros = rate
//                }
//            }
//        }
//
//        getCurrencies(baseCurrency: "EUR", exchangeToCurrency: "USD") { (rate) in
//            if var rate = rate{
//                DispatchQueue.main.async {
//                    rate = (rate * 100).rounded() / 100
//                    CurrencySettings.euroInDollars = rate
//                }
//            }
//        }
        
        getCurrency(baseCurrency: "EUR", exchangeToCurrency: "RUB")
        getCurrency(baseCurrency: "EUR", exchangeToCurrency: "USD")
        getCurrency(baseCurrency: "USD", exchangeToCurrency: "RUB")
        getCurrency(baseCurrency: "USD", exchangeToCurrency: "EUR")
        
    }
    
    func getCurrency(baseCurrency: String, exchangeToCurrency: String) {
        getCurrencies(baseCurrency: baseCurrency, exchangeToCurrency: exchangeToCurrency) { (rate) in
            if var rate = rate{
                DispatchQueue.main.async {
                    rate = (rate * 100).rounded() / 100
                    
                    switch baseCurrency {
                    case "EUR":
                        if exchangeToCurrency == "RUB" {
                            CurrencySettings.euroInRubles = rate
                        } else {
                            CurrencySettings.euroInDollars = rate
                        }
                    case "USD":
                        if exchangeToCurrency == "RUB" {
                            CurrencySettings.dollarInRubles = rate
                        } else {
                            CurrencySettings.dollarInEuros = rate
                        }
                    default: print("wrong")
                    }
                }
            }
        }
    }
    
}

