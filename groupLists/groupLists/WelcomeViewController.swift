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
    
    var userController = UserController()
    var userEventsController = UserEventsController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Skip login and register views if already logged in
        if Auth.auth().currentUser != nil {
            let currentUserId = Auth.auth().currentUser!.uid
            userController.initUser(welcomeViewController: self, userEventsController: userEventsController, userId: currentUserId)
        }
    }
    
  
    @IBAction func logInButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showLogIn", sender: nil)
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showRegister", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showUser") {
            let destinationVC = segue.destination as! EventCollectionViewController
            destinationVC.userController = userController
            destinationVC.userEventsController = userEventsController
        }
        else if (segue.identifier == "showLogIn") {
            let destinationVC = segue.destination as! LogInViewController
            destinationVC.userController = userController
            destinationVC.userEventsController = userEventsController
        }
        else if (segue.identifier == "showRegister") {
            let destinationVC = segue.destination as! RegisterViewController
            destinationVC.userController = userController
            destinationVC.userEventsController = userEventsController
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
