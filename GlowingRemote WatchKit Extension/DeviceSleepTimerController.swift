//
//  DeviceSleepTimerController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 28.07.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import WatchKit
import Foundation


class DeviceSleepTimerController: WKInterfaceController {
    
    @IBOutlet weak var picker : WKInterfacePicker!
    
    let timerValues: [String] = ["1min", "5min", "10min", "30min", "60min", "120min"]
    let timerMinutes: [Int] = [1, 5, 10, 30, 60, 120]
    var currentSelection: Int = 1

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let pickerItems : [WKPickerItem] = timerValues.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.0
            pickerItem.caption = $0.0
            return pickerItem
        }
        picker.setItems(pickerItems)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerSelectedItemChanged(value: Int) {
        currentSelection = timerMinutes[value]
    }
    
    @IBAction func createTimerButtonTapped() {
        print("Choice: \(currentSelection)min")
        popController()
    }
}
