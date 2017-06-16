//
//  PECNotificationsViewController.swift
//  PECRealityProgramming
//
//  Created by Inga on 4/30/17.
//  Copyright © 2017 Inga. All rights reserved.
//

import UIKit

class PECNotificationsViewController: UIViewController {

    @IBOutlet weak var notificationTimeLabel1: UILabel!
    @IBOutlet weak var notificationTimeLabel2: UILabel!
    @IBOutlet weak var notificationSwitch1: UISwitch!
    @IBOutlet weak var notificationSwitch2: UISwitch!
    @IBOutlet weak var datePicker1: UIDatePicker!
    @IBOutlet weak var datePicker2: UIDatePicker!
    @IBOutlet weak var fingerTutorial: UIImageView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint! // 37
    @IBOutlet weak var hoursTopConstraint: NSLayoutConstraint! // 33
    
    
    let dateFormatter = DateFormatter()
    fileprivate let ITEMS_KEY = "notificationItems"


    override func viewDidLoad() {
        super.viewDidLoad()

        setupRemindersData()
        adjustTypography()
        determineDeviceDimentions()
        
        let userSawFingerTutorial: Bool = (UserDefaults.standard.object(forKey: "userSawFingerTutorial") != nil)
        if userSawFingerTutorial == true {
            fingerTutorial.isHidden = true
            print("user saw the finger tutorial!")
            
        } else {
            fingerTutorial.isHidden = false
            print("showing finger tutorail!")
        }
        
        UserDefaults.standard.set(true, forKey: "userSawAddRemaindersTutorial")

    }

    
    
    // MARK: - Notification Screen Methods
    
    @IBAction func editPing1ButtonTapped(_ sender: UIButton) {
        print("edit ping 1 button tapped")
        datePicker1.isHidden = false
        datePicker2.isHidden = true
        fingerTutorial.isHidden = true
        UserDefaults.standard.set(true, forKey: "userSawFingerTutorial")
    }
    
    
    @IBAction func editPing2ButtonTapped(_ sender: UIButton) {
        print("edit ping 2 button tapped")
        datePicker2.isHidden = false
        datePicker1.isHidden = true
        fingerTutorial.isHidden = true
        UserDefaults.standard.set(true, forKey: "userSawFingerTutorial")
    }
    
    
    
    
    @IBAction func datePicker1Action(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        notificationTimeLabel1.text = dateFormatter.string(from: datePicker1.date)
    }
    
    
    @IBAction func datePicker2Action(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "h:mm a"
        notificationTimeLabel2.text = dateFormatter.string(from: datePicker2.date)
    }
    
    
    @IBAction func closeNotificationsButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        datePicker1.isHidden = true
        datePicker2.isHidden = true
        
        dateFormatter.dateFormat = "h:mm a"
        let ping1Time = dateFormatter.date(from: notificationTimeLabel1.text!)!
        let ping2Time = dateFormatter.date(from: notificationTimeLabel2.text!)!
        
        var ping1UUID: String = ""
        var ping2UUID: String = ""
        
        let pings = retrievePingsFromUserDefaults() // array of PECNotificationItems
        
        for ping in pings {
            if ping.index == 0 {
                ping1UUID = ping.UUID
            }
            if ping.index == 1 {
                ping2UUID = ping.UUID
            }
        }
        
        let notification1toUpdate = PECNotificationItem(index: 0, UUID: ping1UUID, time: ping1Time, switchIsOn:notificationSwitch1.isOn)
        let notification2toUpdate = PECNotificationItem(index: 1, UUID: ping2UUID, time: ping2Time, switchIsOn:notificationSwitch2.isOn)
        
        // Removing old alarms
        PECNotificationList.sharedInstance.removeItem(notification1toUpdate)
        PECNotificationList.sharedInstance.removeItem(notification2toUpdate)
        
        // Making new alarms
        PECNotificationList.sharedInstance.addItem(notification1toUpdate)
        PECNotificationList.sharedInstance.addItem(notification2toUpdate)
        
    }
    
    
    // MARK: - Helper Methods
    
    func setupRemindersData() {
        
        var time = Date()
        let calendar = NSCalendar.current
        let dateComponents = NSDateComponents()
        dateFormatter.dateFormat = "h:mm a"
        
        let pings = retrievePingsFromUserDefaults()
        
        if pings.isEmpty == false {
            print("we've got pings!")
            print("PING DICT FROM USER DEFAULTS: \(pings)")
            DispatchQueue.main.async {
                self.notificationTimeLabel1.text = self.dateFormatter.string(from: pings[0].time)
                self.notificationSwitch1.isOn = pings[0].switchIsOn
                self.notificationTimeLabel2.text = self.dateFormatter.string(from: pings[1].time)
                self.notificationSwitch2.isOn = pings[1].switchIsOn
            }
            
        } else {
            print("user defaults pings are empty, created pings dictionary in user defaults!")
            
            // Adding 2 default ping items
            dateComponents.hour = 08
            dateComponents.minute = 0
            time = calendar.date(from: dateComponents as DateComponents)!
            let ping1 = PECNotificationItem(index: 0, UUID: UUID().uuidString, time: time, switchIsOn: false)
            
            dateComponents.hour = 22
            time = calendar.date(from: dateComponents as DateComponents)!
            let ping2 = PECNotificationItem(index: 1, UUID: UUID().uuidString, time: time, switchIsOn: false)
            
            // Saving pings into userDefaults
            var pingTimesDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
            pingTimesDictionary[ping1.UUID] = ["index": ping1.index, "UUID": ping1.UUID, "time": ping1.time, "switchIsOn": ping1.switchIsOn]
            pingTimesDictionary[ping2.UUID] = ["index": ping2.index, "UUID": ping2.UUID, "time": ping2.time, "switchIsOn": ping2.switchIsOn]
            UserDefaults.standard.set(pingTimesDictionary, forKey: ITEMS_KEY)
            
            // Setting the notification view labels to ping.time
            DispatchQueue.main.async {
                self.notificationTimeLabel1.text = self.dateFormatter.string(from: ping1.time)
                self.notificationTimeLabel2.text = self.dateFormatter.string(from: ping2.time)
            }
        }
        
        // testing AdTracker number:
        //            let adTrackerID = UIDevice.current.identifierForVendor?.uuidString
        //            print("adTrackerID: \(adTrackerID)") // 6AA00773-174D-449A-B756-1F42859F2EE1  is constant to device
        
    }
    
    
    func adjustTypography() {
        
        let headerParagraphStyle = NSMutableParagraphStyle()
        headerParagraphStyle.lineSpacing = 2
        headerParagraphStyle.alignment = NSTextAlignment.center;
        let attributes: NSDictionary = [NSParagraphStyleAttributeName : headerParagraphStyle,
                                        NSKernAttributeName: CGFloat(4.29)]
        let attributedHeader = NSAttributedString(string: header.text!, attributes:attributes as? [String : AnyObject])
        
        DispatchQueue.main.async {
            self.header.attributedText = attributedHeader
        }
        
        
        let copyParagraphStyle = NSMutableParagraphStyle()
        copyParagraphStyle.lineSpacing = 3
        copyParagraphStyle.alignment = NSTextAlignment.center;
        let textViewFont = UIFont.init(name: "Lato-Regular", size: 15)
        let textViewAttributes = [NSParagraphStyleAttributeName : copyParagraphStyle,
                                  NSFontAttributeName : textViewFont!,
                                  NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0),
                                  NSKernAttributeName: CGFloat(0.5)] as [String : Any]
        DispatchQueue.main.async {
            self.textView.attributedText = NSAttributedString(string: self.textView.text, attributes:textViewAttributes)
        }
        
    }
    
    
    func determineDeviceDimentions() {
        
        let screenScale = UIScreen.main.scale
        let screenBounds = UIScreen.main.bounds
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale);
        print("screenSize.height:", screenSize.height) // 1136 on yellow 1334 on white yay!  2208.000000 for 6+
        
        if (screenSize.height == 1136.000000) {
            headerTopConstraint.constant = 10
            hoursTopConstraint.constant = 10
            print("iPhone 5 View")
            
        } else if (screenSize.height == 1334.000000) {
            print("iPhone 6 View")
            
        } else {
            print("Not iPhone 5 of 6 View")
        }
        
    }

    
    func retrievePingsFromUserDefaults() -> [PECNotificationItem] {
        let userDefaultsPingsDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(userDefaultsPingsDictionary.values)
        print("userDefaults notifications count: ", items.count)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return PECNotificationItem(index: item["index"] as! Int, UUID: item["UUID"] as! String!, time: item["time"] as! Date, switchIsOn: item["switchIsOn"] as! Bool)
        }).sorted(by: { $0.index < $1.index })
    }
    
}


