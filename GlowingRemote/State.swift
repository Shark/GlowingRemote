//
//  State.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 28.07.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import Foundation

class State: NSObject, NSCoding {
    var power: Bool
    
    init(power: Bool) {
        self.power = power
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init(power: false)
        
        self.power = decoder.decodeObjectForKey("power") as! Bool
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(power, forKey: "power")
    }
}