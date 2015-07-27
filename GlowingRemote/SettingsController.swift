//
//  SettingsController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import UIKit
import WatchConnectivity

class SettingsController: UITableViewController, UITextFieldDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("GRBaseURLCell")!
        let baseUrlField = cell.viewWithTag(1) as! UITextField
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let baseUrl = delegate.stateManager.apiBaseUrl {
            baseUrlField.text = baseUrl.absoluteString
        }
        
        return cell
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let textValue = textField.text {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.stateManager.apiBaseUrl = NSURL(string: textValue)
            
            let context = ["apiBaseUrl": textValue]
            do {
                try WCSession.defaultSession().updateApplicationContext(context)
            } catch {
                print(error)
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}