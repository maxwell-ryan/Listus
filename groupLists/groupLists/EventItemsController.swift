//
//  EventItemsController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/19/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import Firebase

class EventItemsController {
    
    var items : [Item] = [Item(name: "Backpack", id: "ID#12", userID: "USERID#34343", description: "A container to hold items", quantity: 1), Item(name: "Crock Pot", id: "ID#32", userID: "USERID#543", description: "Cookware", quantity: 1), Item(name: "Plates", id: "ID#68", userID: "USERID#99973", description: "For all attendees to eat off of...", quantity: 15), Item(name: "Gas Grill", id: "ID#8", userID: "USERID#87", description: "So we can cook the meat", quantity: 2)]
    var ref : DatabaseReference!
    
    
    //creates a new Item, with only required object attributes, and returns the newly created object
    func createItem(name: String, id: String, userID: String) -> Item {
        
        let newItem = Item(name: name, id: id, userID: userID)
        
        items.append(newItem)
        
        return newItem
    }
    
    //creates a new Item with more detailed object attributes
    func createItem(name: String, id: String, userID: String, description: String, quantity: Int) -> Item {
        
        let newItem = Item(name: name, id: id, userID: userID, description: description, quantity: quantity)
        
        items.append(newItem)
        
        return newItem
    }
    
    //adds given Item to given Event - append to end of list
    func addItem(item: Item) {
        items.append(item)
    }
    
    //adds given Item to given Event - at specific index given
    func addItem(item: Item, atIndex: Int) {
        items.insert(item, at: atIndex)
    }
    
    //removes an item from the given Event's items array using the itemID passed, false returned if itemID matches 0 items
    func removeItem(itemID: String) -> Bool {
        
        for index in 0 ..< items.count {
            if items[index].id == itemID {
                items.remove(at: index)
                return true
            }
        }
        
        return false
    }
    
    //removes an item from the given Event's items array using the index passed, false returned if invalid index passed
    func removeItem(itemIndex: Int) -> Bool {
        
        if itemIndex <= items.count {
            items.remove(at: itemIndex)
            return true
        } else {
            return false
        }
    }
    
}
