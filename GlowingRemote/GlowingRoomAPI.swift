//
//  GlowingRoomAPI.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 17/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation

class GlowingRoomAPI {
    static func getAllDevices(baseUrl: NSURL, completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let allDevicesUrl = baseUrl.URLByAppendingPathComponent("/devices")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(allDevicesUrl, completionHandler: {data, response, error -> Void in
            if error != nil {
                return completionHandler(nil, error);
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                return completionHandler(json, nil)
            } catch {
                return completionHandler(nil, nil)
            }
        })!
        task.resume()
    }
    
    static func switchOn(baseUrl: NSURL, device : NSDictionary, completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let id = device["id"] as! Int
        let type = device["type"] as! String
        var switchOnUrl : NSURL?
        if type == "RGBStrip" {
            switchOnUrl = baseUrl.URLByAppendingPathComponent("/lights/on/\(id)")
        } else if type == "RCSwitch" {
            switchOnUrl = baseUrl.URLByAppendingPathComponent("/switches/on/\(id)")
        }
        
        if(switchOnUrl != nil) {
            let session = NSURLSession.sharedSession()
            let urlRequest = NSMutableURLRequest(URL: switchOnUrl!)
            urlRequest.HTTPMethod = "POST"
        
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data, response, error -> Void in
                if error != nil {
                    return completionHandler(nil, error);
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    return completionHandler(json, nil)
                } catch {
                    return completionHandler(nil, nil)
                }
            })!
            task.resume()
        }
    }
    
    static func switchOff(baseUrl: NSURL, device : NSDictionary, completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let id = device["id"] as! Int
        let type = device["type"] as! String
        var switchOnUrl : NSURL?
        if type == "RGBStrip" {
            switchOnUrl = baseUrl.URLByAppendingPathComponent("/lights/off/\(id)")
        } else if type == "RCSwitch" {
            switchOnUrl = baseUrl.URLByAppendingPathComponent("/switches/off/\(id)")
        }
        
        if(switchOnUrl != nil) {
            let session = NSURLSession.sharedSession()
            let urlRequest = NSMutableURLRequest(URL: switchOnUrl!)
            urlRequest.HTTPMethod = "POST"
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {data, response, error -> Void in
                if error != nil {
                    return completionHandler(nil, error);
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    return completionHandler(json, nil)
                } catch {
                    return completionHandler(nil, nil)
                }
            })!
            task.resume()
        }
    }
}