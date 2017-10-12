//
//  ListViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/9/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase

var model = DataModel()
var testItems: [Item] = [Item(name: "name1", id: "id1", userID: "userID1"), Item(name: "name2", id: "id2", userID: "userID2"), Item(name: "name3", id: "id3", userID: "userID3")]
var testOrganizer = User(firstName: "John", lastName: "Doe", email: "john.doe@gmail.com", id: "1")

let testEvent = Event(name: "testEvent", id: "eventID", date: Date())

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var addListItemBtn: UIButton!
    @IBOutlet weak var listItemTableView: UITableView!

    @IBOutlet weak var listInfoLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user values
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String ?? ""
            let lastName = value?["lastName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            testOrganizer = User(firstName: firstName, lastName: lastName, email: email, id: snapshot.key)
            
            print(testOrganizer.email)
            
            self.formerlyInViewDidLoad()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listItemTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newItemSegue() {
        performSegue(withIdentifier: "addItem", sender: self)
    }
    
    func formerlyInViewDidLoad() {
        listItemTableView.reloadData()
        self.view.backgroundColor = UIColor.white  //UIColor.init(red: 31.0/255.0, green: 40.0/255.0, blue: 51.0/255.0, alpha: 1)
        
        addListItemBtn.setTitleColor(UIColor.init(red: 102.0/255.0, green: 252.0/255.0, blue: 241.0/255.0, alpha: 1), for: UIControlState.normal)
        addListItemBtn.backgroundColor = UIColor.init(red: 197.0/255.0, green: 198.0/255.0, blue: 199.0/255.0, alpha: 1)
        addListItemBtn.layer.cornerRadius = 10
        addListItemBtn.addTarget(self, action: #selector(newItemSegue), for: UIControlEvents.touchUpInside)
        
        //this will be removed once model creation is moved to actual app launch screen
        testItems[0].description = "An undoubtedly needed item"
        testItems[1].description = "A likely needed item"
        testItems[2].description = "A silly item to bring to this event"
        
        
        model.addEvent(name: "testEvent", id: "eventID", date: Date())
        model.events[0].organizer.append(testOrganizer)
        model.events[0].items = testItems
        
        listItemTableView.dataSource = self
        listItemTableView.delegate = self
        
        listItemTableView.backgroundColor = UIColor.init(red: 31.0/255.0, green: 40.0/255.0, blue: 51.0/255.0, alpha: 1)
        
        listInfoLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listInfoLabel.text = "Organized by \(model.events[0].organizer[0].firstName) \(model.events[0].organizer[0].lastName)    |    \(model.events[0].items.count) items suggested"
        
        listNameLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listNameLabel.text = model.events[0].name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //implement UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.events[0].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let listItemCell = listItemTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListItemTableViewCell
            
            listItemCell.itemNameLabel.text = model.events[0].items[indexPath.row].name
            listItemCell.itemDescriptionLabel.text = model.events[0].items[indexPath.row].description
            listItemCell.itemUserLabel.text = "| Suggested by \(model.events[0].items[indexPath.row].userID) |"
            
            listItemCell.backgroundColor = UIColor.init(red: 31.0/255.0, green: 40.0/255.0, blue: 51.0/255.0, alpha: 1)
            listItemCell.itemNameLabel.textColor = UIColor.init(red: 197.0/255.0, green: 198.0/255.0, blue: 199.0/255.0, alpha: 1)
            listItemCell.itemDescriptionLabel.textColor = UIColor.init(red: 197.0/255.0, green: 198.0/255.0, blue: 199.0/255.0, alpha: 1)
            
            listItemCell.itemUserLabel.textColor = UIColor.init(red: 102.0/255.0, green: 252.0/255.0, blue: 241.0/255.0, alpha: 1)
            
            
            return listItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //no implementation of row selection yet
        //could be used for detailed view of item information
        print("Selected row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action: UITableViewRowAction, index: IndexPath) in
            print("Edit button pressed")
        }
        edit.backgroundColor = UIColor.cyan
        
        let concur = UITableViewRowAction(style: .default, title: "Concur") { (action: UITableViewRowAction, index: IndexPath) in
            print("Concur button presss")
        }
        concur.backgroundColor = UIColor.green
        
        let disagree = UITableViewRowAction(style: .default, title: "Disagree") { (action: UITableViewRowAction, index: IndexPath) in
            print("Disagree button presss")
        }
        disagree.backgroundColor = UIColor.red
        
        return [disagree, concur, edit]
    }

}
