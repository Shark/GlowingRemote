//
//  DeviceTableRowController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit
import WatchConnectivity

class DeviceTableRowController: NSObject {
    var device: Device?
    var stateManager: StateManager?
    
    @IBOutlet var labelView: WKInterfaceLabel!
    @IBOutlet var switchView: WKInterfaceSwitch!
    
    @IBAction func switchAction(value: Bool) {
        if(device != nil) {
            if(value) {
                stateManager!.switchOn(device!, completionHandler: {(success) -> Void in
                    if(success) {
                        if(WCSession.defaultSession().reachable) {
                            WCSession.defaultSession().sendMessage(["id": self.device!.id, "power": self.device!.state.power], replyHandler: nil, errorHandler: {(error) -> Void in
                                print(error)
                            })
                        }
                    }
                })
            } else {
                stateManager!.switchOff(device!, completionHandler: {(success) -> Void in
                    if(success) {
                        if(WCSession.defaultSession().reachable) {
                            WCSession.defaultSession().sendMessage(["id": self.device!.id, "power": self.device!.state.power], replyHandler: nil, errorHandler: {(error) -> Void in
                                print(error)
                            })
                        }
                    }
                })
            }
        }
    }
}
