//
//  TimeStatusModel.swift
//  StopwatchS
//
//  Created by leslie on 11/18/19.
//  Copyright © 2019 leslie. All rights reserved.
//

import UIKit

final class TimeStatusModel {
    
    // computed property doesn't need initializer
    var targetTime: Int {
        get {
            // using macro parameter '#function': the function name as forKey's value
            return UserDefaults.standard.integer(forKey: #function)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var startTime: Date {
        get {
            if let time = UserDefaults.standard.object(forKey: #function) as? Date {
                return time
            }
            return Date()
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var stopWatchIsOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: #function)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var totalTime: Double {
        get {
            return UserDefaults.standard.double(forKey: #function)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    var timerTag: Int {
        get {
            return UserDefaults.standard.integer(forKey: #function)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
}
