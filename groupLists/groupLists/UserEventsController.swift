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
    var ref : DatabaseReference!
    
/***************************************************/
/* DO WE NEED BOTH OF THESE createEvent FUNCTIONS? */
/***************************************************/
    //creates an event, appends it to events array, and returns idx of appended event
    func createEvent(name: String, description: String, date: Date, userController:
        UserController, eventCollectionView: UICollectionView) -> Void {
        
        //format date as string for firebase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)

    
        //send data to firebase
        ref = Database.database().reference()
        
        //gets autogenerated id
        let eventRef = ref.child(DB.events).childByAutoId()
        
        //set values of event
        eventRef.setValue([DB.name: name, DB.date: dateString, DB.description: description])
        eventRef.child(DB.organizers).child(userController.user.id).setValue(true)
        
        //add the event to the users events list
        ref.child(DB.users).child(userController.user.id).child(DB.events).child(eventRef.key).setValue(true)
        
        events.append(Event(name: name, id: eventRef.key, date: date, description: description, creator: userController.user.id, authorizedUsers: [userController.user.id]))
        
        eventCollectionView.reloadData()
        
        //return events.count - 1
    }
    
    //creates an event, appends it to events array
    //I think this is the one currently being called
    func createEvent(name: String, description: String, date: Date, userController:
        UserController) -> Void {
        
        //format date as string for firebase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        
        //send data to firebase
        ref = Database.database().reference()
        
        //gets autogenerated id
        let eventRef = ref.child(DB.events).childByAutoId()
        
        //set values of event
        eventRef.setValue([DB.name: name, DB.date: dateString, DB.description: description, DB.creator: userController.user.id])
        
        eventRef.child(DB.authorizedUsers).child(userController.user.id).setValue(true)
        
        //add the event to the users events list
        ref.child(DB.users).child(userController.user.id).child(DB.events).child(eventRef.key).setValue(true)
        
        events.append(Event(name: name, id: eventRef.key, date: date, description: description, creator: userController.user.id, authorizedUsers: [userController.user.id]))
    }
    
    //edits event in database
    func editEvent(event: Event) {
        //edit event in database
        ref = Database.database().reference().child(DB.events).child(event.id)
        
        //format date as string for firebase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: event.date)
        
        let e = [DB.date: dateString,
                 DB.description: event.description,
                 DB.name: event.name] as [String : Any]
        
        ref.updateChildValues(e)
    }
    
    func editEvent(eventIdx: Int, name: String? = nil, date: Date? = nil, description: String? = nil) {
        
        if eventIdx <= events.count {
            
            let event = self.events[eventIdx]
            
            var newName = name ?? event.name
            var newDate = date ?? event.date
            var newDescription = description ?? event.description
            
            //update event locally
            event.name = newName
            event.date = newDate
            event.description = newDescription
            
            //edit event in database
            ref = Database.database().reference().child(DB.events).child(event.id)
            
            //format date as string for firebase
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: newDate)
            
            let e = [DB.date: dateString,
                     DB.description: newDescription,
                     DB.name: newName] as [String : Any]
            
            ref.updateChildValues(e)
            
        } else {
            
            print("Invalid event index provided")
            return
        }
    }
    
/*********************************************************************************/
/* DO WE NEED THIS? IT SHOULD BE TAKEN CARE OF WHEN REMOVING FROM DATABASE BELOW */
/*********************************************************************************/
    //removes event at index given, returns true if removal successful, returns false if index argument is invalid
    func removeEvent(index: Int) -> Bool {
        
        if index <= events.count - 1 {
            events.remove(at: index)
            return true
        } else {
            return false
        }
    }
    
    //remove event from database and user's events list
    func removeEvent(user: UserController, eventIdx: Int) {
        
        if eventIdx <= events.count {
            let event = self.events[eventIdx]
            
            ref = Database.database().reference()
            
            //removes from database
            ref.child(DB.events).child(event.id).removeValue()
            //remove from current user's list
            ref.child(DB.users).child(user.user.id).child(DB.events).child(event.id).removeValue()
            
            //remove event from events array
            for x in 0..<events.count {
                if events[x].id == event.id {
                    events.remove(at: x)
                    return
                }
            }
            
        } else {
            
            print("Invalid event index provided")
            return
        
        }
    }
    
    //remove event from database and user's events list
    func removeEvent(user: UserController, event: Event, eventCollectionView: UICollectionView) {
        ref = Database.database().reference()
        
        //removes from database
        ref.child(DB.events).child(event.id).removeValue()
        //remove from current user's list
        ref.child(DB.users).child(user.user.id).child(DB.events).child(event.id).removeValue()
        
        //remove event from events array
        for x in 0...events.count {
            if events[x].id == event.id {
                events.remove(at: x)
            }
        }
        
        eventCollectionView.reloadData()
    }
    
    //get user's events from FireBase
    func getDBEvents(userId: String, eventCollectionView: UICollectionView) {
        ref = Database.database().reference()
        var events_list: [String] = []
        
        ref.child(DB.users).child(userId).child(DB.events).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let user_events = snapshot.value as? NSDictionary
            for e in user_events! {
                events_list.append(e.key as! String)
            }
            
            for key in events_list {
                self.ref.child(DB.events).child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let event = snapshot.value as? NSDictionary
                    
                    if event != nil {
                        let id = key
                        let description = event?[DB.description] as? String ?? ""
                        let name = event?[DB.name] as? String ?? ""
                        let dateString = event?[DB.date] as? String ?? "0000-00-00 00:00:00"
                        let creator = event?[DB.creator] as? String ?? ""
                        let allowedUsers = event?[DB.authorizedUsers] as? [String] ?? []
                        
                        // format date from string to date type
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = formatter.date(from: dateString)
                        
                        let temp_event = Event(name: name, id: id , date: date!, description: description, creator: creator, authorizedUsers: allowedUsers)
                        
                        self.events.append(temp_event)
                    } else {
                        //event has been deleted so remove from user's events list
                        self.ref.child(DB.users).child(userId).child(DB.events).child(key).removeValue()
                    }
                    
                    eventCollectionView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
