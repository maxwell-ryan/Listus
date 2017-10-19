//
//  UserEventsController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/19/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import Firebase

class UserEventsController {
    
    var events: [Event] = []
    
    func initUserEvents(welcomeViewController: WelcomeViewController, userId: String) {
        
        // Init array of events from DB here
        
        
        // Segue to inital view after logging in
        welcomeViewController.performSegue(withIdentifier: "showUser", sender: nil)
    }
    
    func initUserEvents(logInViewController: LogInViewController, userId: String) {
        
        // Init array of events from DB here
        
        
        // Segue to inital view after logging in
        logInViewController.performSegue(withIdentifier: "showUser", sender: nil)
    }
    
    
    //creates an event, appends it to events array, and returns idx of appended event
    func createEvent(name: String, id: String, date: Date) -> Int {
        
        events.append(Event(name: name, id: id, date: date))
        
        return events.count - 1
    }
    
    //removes event at index given, returns true if removal successful, returns false if index argument is invalid
    func removeEvent(index: Int) -> Bool {
        
        if index <= events.count - 1 {
            events.remove(at: index)
            return true
        } else {
            return false
        }
        
    }
    
    //returns a tuple type, first value indicates if index passed was valid, if true, the second value gives the count requested
    //if first value is false, index passed was invalid, second value always equal 0 in this instance
    func getItemListCount(forEventIndex eventIdx: Int, inUserEventsController userEventsController: UserEventsController) -> (successful: Bool, listCount: Int) {
        
        if eventIdx <= userEventsController.events.count {
            return (true, userEventsController.events[eventIdx].items.count)
        } else {
            return (false, 0)
        }
    }
}
