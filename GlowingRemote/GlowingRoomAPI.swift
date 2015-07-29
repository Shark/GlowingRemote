//
//  GlowingRoomAPI.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 17/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation

class GlowingRoomAPI {
    static func getAllDevices(baseUrl: NSURL, completionHandler: ((NSArray?) -> Void)?) -> Void {
        let allDevicesUrl = baseUrl.URLByAppendingPathComponent("/devices")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(allDevicesUrl, completionHandler: {data, response, error -> Void in
            if error != nil {
                print(error)
                if completionHandler != nil {
                    completionHandler!(nil);
                }
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                if(completionHandler != nil) {
                    completionHandler!(json)
                }
            } catch {
                if completionHandler != nil {
                    completionHandler!(nil)
                }
            }
        })!
        task.resume()
    }
    
    static func switchOn(baseUrl: NSURL, device : Device, completionHandler: ((Bool) -> Void)?) -> Void {
        switchAction(baseUrl, device: device, action: true, completionHandler: completionHandler)
    }
    
    static func switchOff(baseUrl: NSURL, device : Device, completionHandler: ((Bool) -> Void)?) -> Void {
        switchAction(baseUrl, device: device, action: false, completionHandler: completionHandler)
    }
    
    private static func switchAction(baseUrl: NSURL, device: Device, action: Bool, completionHandler: ((Bool) -> Void)?) -> Void {
        let id = device.id
        let type = device.type
        var switchUrl : NSURL?
        var actionString : String
        if(action) {
            actionString = "on"
        } else {
            actionString = "off"
        }
        if type == "RGBStrip" {
            switchUrl = baseUrl.URLByAppendingPathComponent("/lights/\(actionString)/\(id)")
        } else if type == "RCSwitch" {
            switchUrl = baseUrl.URLByAppendingPathComponent("/switches/\(actionString)/\(id)")
        }
        
        if(switchUrl != nil) {
            let session = NSURLSession.sharedSession()
            let urlRequest = NSMutableURLRequest(URL: switchUrl!)
            urlRequest.HTTPMethod = "POST"
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data, response, error -> Void in
                if error != nil && completionHandler != nil {
                    completionHandler!(false)
                } else if(completionHandler != nil) {
                    completionHandler!(true)
                }
            })!
            task.resume()
        } else {
            if(completionHandler != nil) {
                completionHandler!(false)
            }
        }
    }
}