//
//  DeviceDetailController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 28.07.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit

class DeviceDetailController: WKInterfaceController {
    
    var device : NSDictionary?
    @IBOutlet weak var nameLabel : WKInterfaceLabel!
    @IBOutlet weak var brightnessSlider : WKInterfaceSlider!
    @IBOutlet weak var colorButton : WKInterfaceButton!
    @IBOutlet weak var sleepTimerButton : WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        if let device : NSDictionary = context as? NSDictionary {
            self.device = device
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(device != nil) {
            let devName : String? = device!["name"] as? String
            if(devName != nil) {
                nameLabel.setText(devName)
            }
            
            let type : String? = device!["type"] as? String
            if(type == "RGBStrip") {
                brightnessSlider.setHidden(false)
                colorButton.setHidden(false)
                sleepTimerButton.setHidden(false)
            } else if(type == "RCSwitch") {
                brightnessSlider.setHidden(true)
                colorButton.setHidden(true)
                sleepTimerButton.setHidden(false)
            }
        }
    }
    
    @IBAction func colorButtonClicked() {
    }
    
    
    @IBAction func sleepTimerButtonClicked() {
    }
}