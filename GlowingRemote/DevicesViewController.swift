//
//  ViewController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 17/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import UIKit

class DevicesViewController: UITableViewController {
    var devices : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stateManager = StateManager()
        stateManager.devices { (devices) -> Void in
            self.devices = devices
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numSections = 0
        
        let devPerSect = devicesPerSection(devices)
        if(devPerSect["RCSwitch"]!.count > 0) {
            numSections++
        }
        if(devPerSect["RGBStrip"]!.count > 0) {
            numSections++
        }
        
        return numSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "RGB-Strips"
        } else {
            return "Steckdosen"
        }
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let devPerSect = devicesPerSection(devices)
        
        if(section == 0) {
            return devPerSect["RGBStrip"]!.count
        } else {
            return devPerSect["RCSwitch"]!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("state_cell")!
        let nameLabel : UILabel = cell.viewWithTag(1) as! UILabel
        let stateSwitch : UISwitch = cell.viewWithTag(2) as! UISwitch
    
        let devPerSect = devicesPerSection(devices)
        var currentDevice : NSDictionary
        if(indexPath.section == 0) {
            currentDevice = devPerSect["RGBStrip"]![indexPath.row] as! NSDictionary
        } else {
            currentDevice = devPerSect["RCSwitch"]![indexPath.row] as! NSDictionary
        }

        nameLabel.text = currentDevice["name"] as? String
        
        let state = currentDevice["state"] as! NSDictionary
        if (state["power"] as! Bool) == false {
            stateSwitch.setOn(false, animated: false)
        }
        
        stateSwitch.setValue(currentDevice, forKey: "device")
        stateSwitch.addTarget(self, action: "stateSwitchValueDidChange:", forControlEvents: .ValueChanged);
        
        return cell
    }
    
    func stateSwitchValueDidChange(sender: UISwitch!) {
        let device = sender.valueForKey("device") as! NSDictionary
        
        if sender.on {
            GlowingRoomAPI.switchOn(device, completionHandler: { (_, _2) -> Void in })
        } else {
            GlowingRoomAPI.switchOff(device, completionHandler: { (_, _2) -> Void in })
        }
    }
    
    private func devicesPerSection(devices : NSArray?) -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(NSMutableArray(), forKey: "RCSwitch")
        dict.setValue(NSMutableArray(), forKey: "RGBStrip")
        
        if devices != nil {
            for device in devices! {
                let type = device["type"] as? String
                if(type == "RCSwitch") {
                    dict["RCSwitch"]!.addObject(device)
                } else if(type == "RGBStrip") {
                    dict["RGBStrip"]!.addObject(device)
                }
            }
        }
        
        return dict
    }
    
    @IBAction func unwindToDevices(segue: UIStoryboardSegue) {
    }
}

