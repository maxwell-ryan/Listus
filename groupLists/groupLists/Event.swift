//
//  Event.swift
//  groupLists
//
//  Created by bergerMacPro on 10/1/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation

class Event {
    
    var name: String
    var id: String
    var description: String?
    var organizer: [User] = []
    var authorizedUsers: [User] = []
    var date: Date
    
    var items: [Item] = []
    var messages: [Message] = []
    
    init(name: String, id: String, date: Date) {
        
        self.name = name
        self.id = id
        self.date = date
    }
    
    
    
}
