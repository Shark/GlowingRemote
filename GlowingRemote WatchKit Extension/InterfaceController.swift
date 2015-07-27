//
//  InterfaceController.swift
//  GlowingRemote WatchKit Extension
//
//  Created by Felix Seidel on 17/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var devicesTable: WKInterfaceTable!
    
    var devices: NSArray?
    
    override init() {
        super.init()
        
        refreshDevices()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshDevices", name: "ApiBaseUrlChanged", object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func loadTableData() {
        devicesTable.setNumberOfRows(0, withRowType: "Device")
        
        if(devices != nil) {
            devicesTable.setNumberOfRows(devices!.count, withRowType: "Device")
            
            let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
            
            for (index, device) in devices!.enumerate() {
                let row = devicesTable.rowControllerAtIndex(index) as! DeviceTableRowController
                row.device = device as? NSDictionary
                row.stateManager = stateManager
                
                row.label.setText(device["name"] as? String)
                let state = device["state"] as! NSDictionary
                if let power = state["power"] as? Bool {
                    row.switchView.setOn(power)
                }
            }
        }
    }

    @IBAction func refreshDevices() {
        let stateManager = StateManager()
        stateManager.devices { (devices) -> Void in
            self.devices = devices
            
            dispatch_async(dispatch_get_main_queue()) {
                self.loadTableData()
            }
        }
    }
}
