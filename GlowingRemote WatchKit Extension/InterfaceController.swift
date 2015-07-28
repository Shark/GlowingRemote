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
    @IBOutlet weak var loadingDevicesLabel: WKInterfaceLabel!
    @IBOutlet weak var devicesNotAvailableLabel: WKInterfaceLabel!
    
    var devices: Array<Device>?
    
    override init() {
        super.init()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDevices", name: "ApiBaseUrlChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStateLocal", name: "DevicesChanged", object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        loadingDevicesLabel.setHidden(false)
        devicesNotAvailableLabel.setHidden(true)
        
        let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
        if(stateManager.devices == nil || stateManager.devices!.count == 0) {
            updateDevices()
        } else {
            updateState()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ApiBaseUrlChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "DevicesChanged", object: nil)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let device = devices![rowIndex]
        pushControllerWithName("DeviceDetail", context: device)
    }
    
    private func loadTableData() {
        loadingDevicesLabel.setHidden(true)
        devicesTable.setNumberOfRows(0, withRowType: "Device")
        
        if(devices != nil) {
            devicesNotAvailableLabel.setHidden(true)
            devicesTable.setNumberOfRows(devices!.count, withRowType: "Device")
            
            let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
            
            for (index, device) in devices!.enumerate() {
                let row = devicesTable.rowControllerAtIndex(index) as! DeviceTableRowController
                row.device = device as! Device
                row.stateManager = stateManager
                
                row.labelView.setText(device.name)
                row.switchView.setOn(device.state.power)
            }
        } else {
            devicesNotAvailableLabel.setHidden(false)
        }
    }

    @IBAction func updateDevices() {
        let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
        
        stateManager.updateDevices({ (success) -> Void in
            if(success) {
                self.devices = stateManager.devices
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.loadTableData()
            }
        })
    }
    
    private func updateState() {
        let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
        
        self.devices = stateManager.devices
        dispatch_async(dispatch_get_main_queue()) {
            self.loadTableData()
        }
        
        stateManager.updateState({ (success) -> Void in
            if(success) {
                self.devices = stateManager.devices
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadTableData()
                }
            }
        })
    }
    
    func updateStateLocal() {
        let stateManager = (WKExtension.sharedExtension().delegate as! ExtensionDelegate).stateManager
        
        self.devices = stateManager.devices
        dispatch_async(dispatch_get_main_queue()) {
            self.loadTableData()
        }
    }
}
