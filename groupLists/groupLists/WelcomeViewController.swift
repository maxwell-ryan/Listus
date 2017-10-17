//
//  WelcomeViewController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/10/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    var ref : DatabaseReference!
    var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Skip login and register views if already logged in
        // Will uncomment when a sign out button is created
        
        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser?.uid
            
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user name
                
                let value = snapshot.value as? NSDictionary
                let firstName = value?["firstName"] as? String ?? ""
                let lastName = value?["lastName"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                
                let userController = UserController()
                self.user = userController.createUser(firstName: firstName, lastName: lastName, email: email, id: userID!)
                
                print(firstName, lastName, email, userID!)
                
                self.performSegue(withIdentifier: "showUser", sender: nil)
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showUser") {
            let destinationVC = segue.destination as! EventCollectionViewController
            destinationVC.user = user
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
