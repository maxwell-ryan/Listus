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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        
        print("EventID: ", eventId, "\n\n")
        
        // Change send button color to blue
        let origImage = UIImage(named: "ic_send_3x")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)
        sendButton.tintColor = .blue
        
        // Configure the UI
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 140
        
        eventMessagesController.getMessages()
        
        messageTableView.separatorStyle = .none
    }
    
    func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        messageCell.messageBody.text = "Hi dude"
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
