//
//  UserController.swift
//  groupLists
//
//  Created by Kyle Cross on 10/17/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation

class UserController {
    var user : User!
    
    func createUser(firstName: String, lastName: String, email: String, id: String) -> User {
        self.user = User(firstName: firstName, lastName: lastName, email: email, id: id)
        return self.user
    }
}
