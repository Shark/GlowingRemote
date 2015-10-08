//
//  SettingsController.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 22/07/15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import UIKit
import WatchConnectivity

class SettingsController: UITableViewController {
    weak var apiBaseUrlTextField : UITextField?
    
    override func viewWillDisappear(animated: Bool) {
        saveValues()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("GRBaseURLCell")!
        let baseUrlField = cell.viewWithTag(1) as! UITextField
        apiBaseUrlTextField = baseUrlField
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let baseUrl = delegate.stateManager.apiBaseUrl {
            baseUrlField.text = baseUrl.absoluteString
        }
        
        return cell
    }
    
    private func saveValues() {
        if let textValue = apiBaseUrlTextField?.text {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.stateManager.apiBaseUrl = NSURL(string: textValue)
            delegate.stateManager.devices = nil
        }
    }
}