//
//  LogInViewController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/10/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    var userController: UserController!
    var userEventsController: UserEventsController!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        if let email = self.emailField.text, let password = self.passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
                if let error = error {
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                let userId = Auth.auth().currentUser!.uid
                
                self.userController.initUser(logInViewController: self, userEventsController: self.userEventsController, userId: userId)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showUser") {
            let destinationVC = segue.destination as! EventCollectionViewController
            destinationVC.userController = userController
            destinationVC.userEventsController = userEventsController
        }
    }
}
