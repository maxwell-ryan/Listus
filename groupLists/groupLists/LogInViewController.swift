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
    
    var user : User!
    var ref: DatabaseReference!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Skip login and register views if already logged in
        // Will place in welcomeViewController when sign out button is created
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                self.ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user name
                    
                    let value = snapshot.value as? NSDictionary
                    let firstName = value?["firstName"] as? String ?? ""
                    let lastName = value?["lastName"] as? String ?? ""
                    
                    let userController = UserController()
                    self.user = userController.createUser(firstName: firstName, lastName: lastName, email: email, id: user!.uid)
                    
                    self.performSegue(withIdentifier: "showUser", sender: nil)
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showUser") {
            let destinationVC = segue.destination as! EventCollectionViewController
            destinationVC.user = user
        }
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
