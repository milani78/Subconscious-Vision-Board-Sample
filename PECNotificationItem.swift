//
//  PECNotificationItem.swift
//  PECRealityProgramming
//
//  Created by Inga on 3/2/17.
//  Copyright © 2017 Inga. All rights reserved.
//

import Foundation

struct PECNotificationItem {
    var index: Int
    var UUID: String
    var time: Date
    var switchIsOn: Bool
    
    init(index: Int, UUID: String, time: Date, switchIsOn: Bool) {
        self.index = index
        self.UUID = UUID
        self.time = time
        self.switchIsOn = switchIsOn
    }
}
