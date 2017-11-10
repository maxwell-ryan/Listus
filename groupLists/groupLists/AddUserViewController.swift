//
//  AddUserViewController.swift
//  groupLists
//
//  Created by Valerie P Brown on 11/10/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class AddUserViewController: UIViewController {
    var ref : DatabaseReference!
    
    @IBOutlet weak var navBtn: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var isOrganizer: UISwitch!
    let navigationLauncher = NavigationLauncher()
    var userEventsController = UserEventsController.init()
    var eventIdx = Int()
    
    @IBAction func cancelAdd(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addUser(_ sender: Any) {
        ref = Database.database().reference()
        let permissions = isOrganizer.isOn
        let eventID = userEventsController.events[eventIdx].id
        
        
        //query for user's key based on user's email
        ref.child(DB.users).queryOrdered(byChild:  "email").queryStarting(atValue: userEmail.text).queryEnding(atValue: userEmail.text).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            
            if user != nil {
                let userID = user!.allKeys[0] as? String
               
                //add user to event's authorizedUsers
                self.ref.child(DB.events).child(eventID).child(DB.authorizedUsers).child(userID!).setValue(permissions)
                self.userEventsController.events[self.eventIdx].authorizedUsers.setValue(permissions, forKey: userID!)
                
                //add the event to the user's events list
                self.ref.child(DB.users).child(userID!).child(DB.events).child(eventID).setValue(true)
                self.dismiss(animated: true)
            } else {
                //alert user that the other user doesn't exist
                let alert = UIAlertController(title: "Error", message: "User does not exist", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBtn.setImage(UIImage(named: "menu2x"), for: UIControlState.normal)
        navBtn.showsTouchWhenHighlighted = true
        navBtn.tintColor = UIColor.darkGray
        navBtn.addTarget(self, action: #selector(displayNav), for: .touchUpInside)
        
        
        view.backgroundColor = colors.primaryColor1
        
        cancelButton.backgroundColor = colors.primaryColor2
        cancelButton.setTitleColor(colors.accentColor1, for: UIControlState.normal)
        cancelButton.layer.cornerRadius = 10
        
        addButton.backgroundColor = colors.primaryColor2
        addButton.setTitleColor(colors.accentColor1, for: UIControlState.normal)
        addButton.layer.cornerRadius = 10
    }
    
    func displayNav() {
        
        navigationLauncher.baseAddUserVC = self
        navigationLauncher.showMenu()
    }
    
    func executeNavOption(option: NavOption) {
        
        if option.name == "Cancel" {
            //cancel selected, do nothing
        }
        else if option.name == "My Events" {
            //go to events view
            dismiss(animated: true)
        } else if option.name == "Logout" {
            //logout via firebase
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "returnToLogin", sender: self)
                
            } catch {
                print("A logout error occured")
            }
        }
    }

}
