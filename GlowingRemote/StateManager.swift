//
//  StateManager.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation
import WatchConnectivity

class StateManager {
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
            
            if newBaseUrl != nil {
                let context = ["apiBaseUrl": newBaseUrl!]
                do {
                    try WCSession.defaultSession().updateApplicationContext(context)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private var cachedDevices : Array<Device>?
    var devices: Array<Device>? {
        get {
            if(cachedDevices != nil) {
                return cachedDevices
            } else {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey("devices") as? NSData {
                    let result = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Array<Device>
                    self.cachedDevices = result
                    return result
                } else {
                    return nil
                }
            }
        }
        set(newDevices) {
            var data : NSData?
            if(newDevices != nil) {
                data = NSKeyedArchiver.archivedDataWithRootObject(newDevices!)
            } else {
                data = nil
            }
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "devices")
            cachedDevices = newDevices
        }
    }
    
    func updateDevices(completionHandler: ((Bool) -> Void)!) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.getAllDevices(apiBaseUrl!, completionHandler: { (devices) -> Void in
                if(devices != nil) {
                    var deserializedDevices = Array<Device>()
                    for device in devices! {
                        let dictState = device["state"] as! NSDictionary
                        let state = State(power: dictState["power"] as! Bool)
                        let id = device["id"] as! Int
                        let name = device["name"] as! String
                        let type = device["type"] as! String
                        let device = Device(id: id, name: name, type: type, state: state)
                        deserializedDevices.append(device)
                    }
                    self.devices = deserializedDevices
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            })
        } else {
            completionHandler(false)
        }
    }
    
    func updateState(completionHandler: ((Bool) -> Void)!) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.getAllDevices(apiBaseUrl!, completionHandler: { (devices) -> Void in
                if(devices != nil) {
                    var states = [Int:State]()
                    for device in devices! {
                        let dictState = device["state"] as! NSDictionary
                        let state = State(power: dictState["power"] as! Bool)
                        let id = device["id"] as! Int
                        states[id] = state
                    }
                    
                    if self.devices != nil {
                        for device in self.devices! {
                            if let stateForCurrentDevice = states[device.id] {
                                device.state = stateForCurrentDevice
                            }
                        }
                    }
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            })
        } else {
            completionHandler(false)
        }
    }
    
    func switchOn(device: Device, completionHandler: ((Bool) -> Void)?) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.switchOn(apiBaseUrl!, device: device, completionHandler: {(success) -> Void in
                if(success) {
                    device.state.power = true
                    if(completionHandler != nil) {
                        completionHandler!(true)
                    }
                } else if(completionHandler != nil) {
                    completionHandler!(false)
                }
            })
        } else if(completionHandler != nil) {
            completionHandler!(false)
        }
    }
    
    func switchOff(device: Device, completionHandler: ((Bool) -> Void)?) {
        if(apiBaseUrl != nil) {
            GlowingRoomAPI.switchOff(apiBaseUrl!, device: device, completionHandler: {(success) -> Void in
                if(success) {
                    device.state.power = false
                    if(completionHandler != nil) {
                        completionHandler!(true)
                    }
                } else if(completionHandler != nil) {
                    completionHandler!(false)
                }
            })
        } else if(completionHandler != nil) {
            completionHandler!(false)
        }
    }
}