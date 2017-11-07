//
//  MessagingViewController.swift
//  groupLists
//
//  Created by Kyle Cross on 11/4/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var userController: UserController!
    var userEventsController: UserEventsController!
    var eventMessagesController = EventMessagesController()
    var eventId: String!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        messageTableView.backgroundColor = colors.primaryColor1
        textFieldView.backgroundColor = colors.primaryColor1
        
        print("EventID: ", eventId, "\n\n")
        print("UserID: ", userController.user.id, "\n\n")
        print("SenderName: ", userController.user.firstName, " ", userController.user.lastName, "\n\n")
        
        // Change send button color to blue
        let origImage = UIImage(named: "ic_send_3x")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)
        sendButton.tintColor = colors.accentColor1
        
        // Configure the UI
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 140
        
        eventMessagesController.getMessages(userId: userController.user.id, eventId: eventId, messageTableView: messageTableView)
        
        messageTableView.separatorStyle = .none
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        eventMessagesController.createMessage(userController: userController, eventId: eventId, messageTextField: messageTextField, sendButton: sendButton, date: Date())
    }
    
    
    func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.textHeightConstraint.constant = 260
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.textHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        let message = eventMessagesController.messages[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        messageCell.messageBody.text = message.messageBody
        messageCell.senderName.text = message.senderName
        messageCell.messageTime.text = dateFormatter.string(from: message.timestamp)
        
        messageCell.backgroundColor = colors.primaryColor1
        messageCell.senderName.textColor = colors.primaryColor2
        messageCell.messageTime.textColor = colors.primaryColor2
        messageCell.messageBody.textColor = colors.primaryColor1
        
        if message.senderID == userController.user.id {
            messageCell.messageBodyView.backgroundColor = colors.accentColor1
        }
        else {
            messageCell.messageBodyView.backgroundColor = colors.primaryColor2
        }
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventMessagesController.messages.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
