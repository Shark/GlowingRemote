//
//  DeviceTableRowController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit

class DeviceTableRowController: NSObject {
    var device: NSDictionary?
    
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var switchView: WKInterfaceSwitch!
    
    @IBAction func switchAction(value: Bool) {
        if(device != nil) {
            if(value) {
                GlowingRoomAPI.switchOn(device!, completionHandler: { (_, _2) -> Void in })
            } else {
                GlowingRoomAPI.switchOff(device!, completionHandler: { (_, _2) -> Void in })
            }
        }
    }
}
