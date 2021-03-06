//
//  ViewController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 17/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import UIKit
import WatchConnectivity

class DevicesViewController: UITableViewController {
    var devices : Array<Device>?
    var stateManager : StateManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        stateManager = delegate.stateManager
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "StateChanged", object: nil)
        
        self.devices = stateManager?.devices
        
        if(self.devices == nil) {
            updateDevices()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "refresh", object: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
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
        var currentDevice : Device
        if(indexPath.section == 0) {
            currentDevice = devPerSect["RGBStrip"]![indexPath.row] as! Device
        } else {
            currentDevice = devPerSect["RCSwitch"]![indexPath.row] as! Device
        }

        nameLabel.text = currentDevice.name
        stateSwitch.setOn(currentDevice.state.power, animated: true)
        
        stateSwitch.setValue(currentDevice, forKey: "device")
        stateSwitch.addTarget(self, action: "stateSwitchValueDidChange:", forControlEvents: .ValueChanged);
        
        return cell
    }
    
    func stateSwitchValueDidChange(sender: UISwitch!) {
        let device = sender.valueForKey("device") as! Device
        
        if sender.on {
            stateManager!.switchOn(device, completionHandler: {(Bool) -> Void in
                if(WCSession.defaultSession().reachable) {
                    WCSession.defaultSession().sendMessage(["id": device.id, "power": device.state.power], replyHandler: nil, errorHandler: {(error) -> Void in
                        print(error)
                    })
                }
            })
        } else {
            stateManager!.switchOff(device, completionHandler: {(Bool) -> Void in
                if(WCSession.defaultSession().reachable) {
                    WCSession.defaultSession().sendMessage(["id": device.id, "power": device.state.power], replyHandler: nil, errorHandler: {(error) -> Void in
                        print(error)
                    })
                }
            })
        }
    }
    
    private func devicesPerSection(devices : NSArray?) -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(NSMutableArray(), forKey: "RCSwitch")
        dict.setValue(NSMutableArray(), forKey: "RGBStrip")
        
        if devices != nil {
            for device in devices! {
                let type = (device as! Device).type
                if(type == "RCSwitch") {
                    dict["RCSwitch"]!.addObject(device)
                } else if(type == "RGBStrip") {
                    dict["RGBStrip"]!.addObject(device)
                }
            }
        }
        
        return dict
    }
    
    func updateDevices() {
        stateManager!.updateDevices({ (success) -> Void in
            if(success) {
                self.devices = self.stateManager!.devices
                self.updateDeviceContext(self.devices!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if(success) {
                    self.tableView.reloadData()
                } else {
                    self.showDevicesNotAvailableAlert()
                }
            }
        })
    }
    
    func updateStateRemotely() {
        stateManager!.updateState({ (success) -> Void in
            if(success) {
                self.devices = self.stateManager!.devices
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.updateDeviceContext(self.devices!)
                }
            }
        })
    }
    
    func refresh() {
        self.devices = self.stateManager!.devices
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.updateDeviceContext(self.devices!)
        }
    }
    
    func updateDeviceContext(devices: Array<Device>) {
        let context = ["devices": devices]
        do {
            try WCSession.defaultSession().updateApplicationContext(context)
        } catch {
            print(error)
        }
    }
    
    @IBAction func unwindToDevices(segue: UIStoryboardSegue) {
    }
    
    private func showDevicesNotAvailableAlert() {
        dispatch_async(dispatch_get_main_queue()) {
            let baseUrl = self.stateManager?.apiBaseUrl?.absoluteString
            let alertController = UIAlertController(title: "Fehler", message: "Konnte Geräte nicht von \(baseUrl) laden.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default) { (action) in })
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

