//
//  Device.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 28.07.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation

class Device: NSObject, NSCoding {
    var id: Int
    var name: String
    var type: String
    var state: State
    
    init(id: Int, name: String, type: String, state: State) {
        self.id = id
        self.name = name
        self.type = type
        self.state = state
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init(id: 0, name: "", type: "", state: State(power: false))
        
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.name = decoder.decodeObjectForKey("name") as! String
        self.type = decoder.decodeObjectForKey("type") as! String
        self.state = decoder.decodeObjectForKey("state") as! State
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(type, forKey: "type")
        coder.encodeObject(state, forKey: "state")
    }
}