//
//  ListViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/9/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase



class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var currentEventIdx: Int! //unwrapped optional required to prevent Xcode mandating this class have an initializer - let's discuss best practice, I am unsure
    
    @IBOutlet weak var addListItemBtn: UIButton!
    @IBOutlet weak var listItemTableView: UITableView!

    @IBOutlet weak var listInfoLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.ref = Database.database().reference()

//        let userID = Auth.auth().currentUser?.uid
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user values
//            let value = snapshot.value as? NSDictionary
//            let firstName = value?["firstName"] as? String ?? ""
//            let lastName = value?["lastName"] as? String ?? ""
//            let email = value?["email"] as? String ?? ""
//
//            testOrganizer = User(firstName: firstName, lastName: lastName, email: email, id: snapshot.key)
//
//            print(testOrganizer.email)

            self.formerlyInViewDidLoad()

//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listItemTableView.reloadData()
        print("ListViewController scoped on event idx: \(currentEventIdx!)")
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
        self.view.backgroundColor = UIColor.white  //colors.primaryColor1
        
        addListItemBtn.setTitleColor(colors.accentColor1, for: UIControlState.normal)
        addListItemBtn.backgroundColor = colors.primaryColor2
        addListItemBtn.layer.cornerRadius = 10
        addListItemBtn.addTarget(self, action: #selector(newItemSegue), for: UIControlEvents.touchUpInside)
        
        listItemTableView.dataSource = self
        listItemTableView.delegate = self
        
        listItemTableView.backgroundColor = colors.primaryColor1
        
        listInfoLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listInfoLabel.text = "Organized by \(model.events[currentEventIdx].organizer[0].firstName) \(model.events[currentEventIdx].organizer[0].lastName)    |    \(model.events[currentEventIdx].items.count) items suggested"
        
        listNameLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listNameLabel.text = model.events[currentEventIdx].name
    }
    
    //implement UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.events[currentEventIdx].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let listItemCell = listItemTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListItemTableViewCell
            
            listItemCell.itemNameLabel.text = model.events[currentEventIdx].items[indexPath.row].name
            listItemCell.itemDescriptionLabel.text = model.events[currentEventIdx].items[indexPath.row].description
            listItemCell.itemUserLabel.text = "| Suggested by \(model.events[currentEventIdx].items[indexPath.row].userID) |"
            
            listItemCell.backgroundColor = colors.primaryColor1
            listItemCell.itemNameLabel.textColor = colors.primaryColor2
            listItemCell.itemDescriptionLabel.textColor = colors.primaryColor2
            
            listItemCell.itemUserLabel.textColor = colors.accentColor1
            
            
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
            let cell = tableView.cellForRow(at: indexPath)!
            cell.tag = indexPath.row
            self.performSegue(withIdentifier: "editItem", sender: cell)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editItem" {
            let selectedRow = sender as! ListItemTableViewCell
            print("selectedRow cell tag is: \(selectedRow.tag)")
            let destinationVC = segue.destination as! AddItemViewController
            
            //maintain current event scope/idx
            destinationVC.currentEventIdx = self.currentEventIdx
            destinationVC.editIdx = selectedRow.tag
            print("In prepare sugue, currentEventIdx is scoped on: \(currentEventIdx)")
            //pre-populate the selected item (by row/tag) with the existing item information
            //destinationVC.itemNameTextField!.text = "test name"//model.events[currentEventIdx].items[selectedRow.tag].name
            //destinationVC.descriptionTextField!.text = "test desc."//model.events[currentEventIdx].items[selectedRow.tag].description
            //destinationVC.userTextField!.text = "test user"//model.events[currentEventIdx].items[selectedRow.tag].userID
            //destinationVC.idTextField!.text = "test id"//model.events[currentEventIdx].items[selectedRow.tag].id
            //destinationVC.quantityStepper!.value = 12.0//Double(model.events[currentEventIdx].items[selectedRow.tag].quantity!)
            
            //adjust add item button to state: update item
            //destinationVC.submitNewItemBtn.setTitle("Update Item", for: .normal)

        } else if segue.identifier == "addItem" {
            
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.currentEventIdx = self.currentEventIdx
        }
    }

}
