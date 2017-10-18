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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Skip login and register views if already logged in
        if Auth.auth().currentUser != nil {
            self.userController.createUser(welcomeViewController: self, userId: Auth.auth().currentUser!.uid)
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
        }
        else if (segue.identifier == "showLogIn") {
            let destinationVC = segue.destination as! LogInViewController
            destinationVC.userController = userController
        }
        else if (segue.identifier == "showRegister") {
            let destinationVC = segue.destination as! RegisterViewController
            destinationVC.userController = userController
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
