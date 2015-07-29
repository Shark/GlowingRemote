//
//  DeviceDetailController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 28.07.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit

class DeviceDetailController: WKInterfaceController {
    
    var device : Device?
    @IBOutlet weak var nameLabel : WKInterfaceLabel!
    @IBOutlet weak var brightnessSlider : WKInterfaceSlider!
    @IBOutlet weak var colorButton : WKInterfaceButton!
    @IBOutlet weak var sleepTimerButton : WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        if let device : Device? = context as? Device {
            self.device = device
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(device != nil) {
            nameLabel.setText(device!.name)
            
            if(device!.type == "RGBStrip") {
                brightnessSlider.setHidden(false)
                colorButton.setHidden(false)
                sleepTimerButton.setHidden(false)
            } else if(device!.type == "RCSwitch") {
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