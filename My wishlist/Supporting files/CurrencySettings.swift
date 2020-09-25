//
//  CurrencySettings.swift
//  My wishlist
//
//  Created by Дмитрий on 24.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import Foundation

final class CurrencySettings {
    
    private enum SettingsKeys: String {
        case dollarInRubles
        case euroInRubles
        case dollarInEuros
        case euroInDollars
        
        
    }
    
    static var dollarInRubles: Double? {
        
        get {
            return UserDefaults.standard.double(forKey: SettingsKeys.dollarInRubles.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.dollarInRubles.rawValue
            if let enable = newValue {
                defaults.set(enable, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
    
    static var euroInRubles: Double? {
        
        get {
            return UserDefaults.standard.double(forKey: SettingsKeys.euroInRubles.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.euroInRubles.rawValue
            if let enable = newValue {
                defaults.set(enable, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
    
    static var dollarInEuros: Double? {
        
        get {
            return UserDefaults.standard.double(forKey: SettingsKeys.dollarInEuros.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.dollarInEuros.rawValue
            if let enable = newValue {
                defaults.set(enable, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
    
    static var euroInDollars: Double? {
        
        get {
            return UserDefaults.standard.double(forKey: SettingsKeys.euroInDollars.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.euroInDollars.rawValue
            if let enable = newValue {
                defaults.set(enable, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
    }

}
