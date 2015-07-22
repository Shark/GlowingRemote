//
//  StateManager.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation

class StateManager {
    var storedDevices : NSArray?
    
    // For storing and retrieving devices NSArray:
    //   NSUserDefaults.standardUserDefaults().objectForKey("devices") as? NSData
    //   NSKeyedUnarchiver.unarchiveObjectWithData(storedDevicesData) as? NSArray
    //   let storedDevicesData = NSKeyedArchiver.archivedDataWithRootObject(devices)
    //   NSUserDefaults.standardUserDefaults().setValue(storedDevicesData, forKey: "devices")
    
    func devices(completionHandler: ((NSArray?) -> Void)!) {
        if(storedDevices != nil) {
            completionHandler(storedDevices)
        } else {
            GlowingRoomAPI.getAllDevices({ (devices, error) -> Void in
                if(devices != nil) {
                    self.storedDevices = devices
                }
                completionHandler(self.storedDevices)
            })
        }
    }
}