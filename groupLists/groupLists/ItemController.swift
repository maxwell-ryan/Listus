//  ItemController.swift
//  groupLists

import Foundation
import UIKit

class ItemController {
    
    init() {
        
    }
    
    //creates a new Item, with only required object attributes, and returns the newly created object
    func createItem(name: String, id: String, userID: String) -> Item {
        
        var newItem = Item(name: name, id: id, userID: userID)
        
        return newItem
    }
    
    //creates a new Item with more detailed object attributes
    func createItem(name: String, id: String, userID: String, description: String, quantity: Int) -> Item {
        
        var newItem = Item(name: name, id: id, userID: userID, description: description, quantity: quantity)
        
        return newItem
    }
    
    //adds given Item to given Event - append to end of list
    func addItem(toEventItemList event: Event, item: Item) {
        event.items.append(item)
    }
    
    //adds given Item to given Event - at specific index given
    func addItem(toEventItemList event: Event, item: Item, atIndex: Int) {
        event.items.insert(item, at: atIndex)
    }
    
    //removes an item from the given Event's items array using the itemID passed, false returned if itemID matches 0 items
    func removeItem(fromEvent event: Event, itemID: String) -> Bool {

        for index in 0 ..< event.items.count {
            if event.items[index].id == itemID {
                event.items.remove(at: index)
                return true
            }
        }
        
        return false
    }
    
    //removes an item from the given Event's items array using the index passed, false returned if invalid index passed
    func removeItem(fromEvent event: Event, itemIndex: Int) -> Bool {
        
        if itemIndex <= event.items.count {
            event.items.remove(at: itemIndex)
            return true
        } else {
            return false
        }
    }
    
    // Let's discuss if these belong in ItemController, or Item. I wondering if accessing them will be odd if they live here
    // MARK: - Functions to edit each member variable of an Item object
    
    func editItemName(forItem item: Item, newName name: String) {
        item.name = name
    }
    
    func editItemDescription(forItem item: Item, newDescription description: String) {
        item.description = description
    }
    
    func editItemQuantity(forItem item: Item, newQuantity quantity: Int) {
        item.quantity = quantity
    }
    
    func editItemUserID(forItem item: Item, newUserID userID: String) {
        item.description = userID
    }
    
    func editItemID(forItem item: Item, newID id: String) {
        item.id = id
    }
    
    func addItemPicture(forItem item: Item, itemImage image: UIImage) {
        item.picture = image
    }
    
    
    
    
    
}
