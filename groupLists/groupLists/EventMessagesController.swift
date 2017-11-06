//
//  EventMessagesController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/19/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import Firebase

class EventMessagesController {
    var messages: [Message] = []
    var ref : DatabaseReference!
    
    func createMessage() {
        
    }
    
    func getMessages(userId: String, eventId: String, messageTableView: UITableView) {
        
        self.ref = Database.database().reference()
        
        let messagesDB = Database.database().reference().child(DB.messages).child(eventId)
        
        
        messagesDB.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let messageBody = snapshotValue[DB.messageBody]!
            let senderName = snapshotValue[DB.senderName]!
            let senderId = snapshotValue[DB.senderId]!
            let time = snapshotValue[DB.time]!
            
            let message = Message(messageBody: messageBody, timestamp: time, senderID: senderId, senderName: senderName, id: messageId)
            
            self.messages.append(message)
            
            //Reload table data
            messageTableView.rowHeight = UITableViewAutomaticDimension
            messageTableView.estimatedRowHeight = 140
            messageTableView.reloadData()
            
            
            
        
        })
    }
}
