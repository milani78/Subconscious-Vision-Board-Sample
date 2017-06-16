//
//  PECNotificationList.swift
//  PECRealityProgramming
//
//  Created by Inga on 3/2/17.
//  Copyright © 2017 Inga. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class PECNotificationList {
    
    fileprivate let ITEMS_KEY = "notificationItems"

    class var sharedInstance : PECNotificationList {
        struct Static {
            static let instance: PECNotificationList = PECNotificationList()
        }
        return Static.instance
    }
    
    
    func addItem(_ item: PECNotificationItem) {
        
        var userDefaultsPingsDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()  // nil-coalescing operator (??)
        
        // Storing NSData representation of notification in dictionary with UUID as key
        userDefaultsPingsDictionary[item.UUID] = ["index": item.index, "UUID": item.UUID, "time": item.time, "switchIsOn": item.switchIsOn]
        
        // Saving/overwriting UserDefaults dictionary
        UserDefaults.standard.set(userDefaultsPingsDictionary, forKey: ITEMS_KEY)
        print("UPDATED NOTIFICATION in userDefaultsPingsDictionary: \(userDefaultsPingsDictionary)")
        
        if item.switchIsOn == true {
        
            // Creating a corresponding local notification
            let notification = UILocalNotification()
            notification.alertBody = "It's time to realize your dreams!"
            notification.alertAction = "Open"
            notification.fireDate = item.time as Date // todo item due date (when notification will be fired)
            notification.repeatInterval = NSCalendar.Unit.day
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["index": item.index, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
            UIApplication.shared.scheduleLocalNotification(notification)
            print("SCHEDULED NEW NOTIFICATION")
         }
        
    }
    
    
    func removeItem(_ item: PECNotificationItem) {
        let scheduledLocalNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
        guard scheduledLocalNotifications != nil else {return} // Nothing to remove, so return
        
        // Removing item from local notifications
        for notification in scheduledLocalNotifications! {
            if (notification.userInfo!["UUID"] as! String == item.UUID) {
                UIApplication.shared.cancelLocalNotification(notification)
                break
            }
        }
        
        // Updating item in UserDefaults
        if var userDefaultsPingsDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            userDefaultsPingsDictionary[item.UUID] = ["index": item.index, "UUID": item.UUID, "time": item.time, "switchIsOn": item.switchIsOn]
            
            // Saving/overwriting UserDefaults dictionary
            UserDefaults.standard.set(userDefaultsPingsDictionary, forKey: ITEMS_KEY)
            print("REMOVE NOTIFICATION ITEM, userDefaultsPingsDictionary after updating: \(userDefaultsPingsDictionary)")
        }
    }
    
}
