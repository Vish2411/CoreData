//
//  Modal.swift
//  sqliteDemo
//
//  Created by iMac on 30/08/22.
//

import Foundation

struct ModelEmployee
{
    var name: String = ""
    var designation: String = ""
    var id: String = ""
    
    init(name:String, designation: String)
    {
        self.id = UUID().uuidString
        self.name = name
        self.designation = designation
    }
    
    init(id: String, name:String, des: String) {
        self.id = id
        self.name = name
        self.designation = des
    }
    
}


