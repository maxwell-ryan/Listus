//
//  DataModel.swift
//  groupLists


/* 
 Description:
 An class used to create and destroy model layer objects/memory,
 allowing data objects to be instantiated/managed through the app's single
 DataModel object, rather than instantiating many lower level objects within
 ViewControllers
*/

import Foundation

class DataModel {
    
    var events: [Event] = []
    
    init() {
        
    }
    
    func addEvent(name: String, id: String, date: Date) {
        var newEvent: Event = Event(name: name, id: id, date: date)
        events.append(newEvent)
    }
    
    func removeEventAt(index: Int) {
        if (self.events.count > index) {
            self.events.remove(at: index)
        } else {
            print("Invalid subscript for removal")
        }
    }

}
