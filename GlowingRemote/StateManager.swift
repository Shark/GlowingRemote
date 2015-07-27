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
    let api : GlowingRoomAPI = GlowingRoomAPI()
    
    var apiBaseUrl: NSURL? {
        get {
            if let baseUrlString = NSUserDefaults.standardUserDefaults().objectForKey("apiBaseUrl") as? NSString {
                return NSURL(string: baseUrlString as String)
            } else {
                return nil
            }
        }
        set(newBaseUrl) {
            let newBaseUrlString : String = newBaseUrl!.absoluteString
            NSUserDefaults.standardUserDefaults().setValue(newBaseUrlString, forKey: "apiBaseUrl")
            NSNotificationCenter.defaultCenter().postNotificationName("ApiBaseUrlChanged", object: self)
        }
    }
    
    func devices(completionHandler: ((NSArray?) -> Void)!) {
        if(storedDevices != nil) {
            completionHandler(storedDevices)
        } else if(apiBaseUrl != nil) {
            GlowingRoomAPI.getAllDevices(apiBaseUrl!, completionHandler: { (devices, error) -> Void in
                if(devices != nil) {
                    self.storedDevices = devices
                }
                completionHandler(self.storedDevices)
            })
        } else {
            completionHandler(nil)
        }
    }
    
    func switchOn(device: NSDictionary, completionHandler: ((NSArray!, NSError!) -> Void)!) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.switchOn(apiBaseUrl!, device: device, completionHandler: completionHandler)
        } else {
            completionHandler(nil, nil)
        }
    }
    
    func switchOff(device: NSDictionary, completionHandler: ((NSArray!, NSError!) -> Void)!) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.switchOff(apiBaseUrl!, device: device, completionHandler: completionHandler)
        } else {
            completionHandler(nil, nil)
        }
    }
}