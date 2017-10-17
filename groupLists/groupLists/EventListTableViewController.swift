//
//  EventListTableViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/1/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import FirebaseDatabase

//var model = DataModel()
//let testItems: [Item] = [Item(name: "name1", id: "id1", userID: "userID1"), Item(name: "name2", id: "id2", userID: "userID2"), Item(name: "name3", id: "id3", userID: "userID3")]

let testEvent = Event(name: "testEvent", id: "eventID", date: Date())


class EventListTableViewController: UITableViewController {
    var ref: DatabaseReference!
    
    
    @IBOutlet var eventListTableView: UITableView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemIDLabel: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 31.0/255.0, green: 40.0/255.0, blue: 51.0/255.0, alpha: 1)
        
        //this will be removed once model creation is moved to actual app launch screen
        //testItems[0].description = "An undoubtedly needed item"
        //testItems[1].description = "A likely needed item"
        //testItems[2].description = "A silly item to bring to this event"
        
        
        //model.addEvent(name: "testEvent", id: "eventID", date: Date())
        //model.events[0].items = testItems
        
        self.ref = Database.database().reference()
        
        testEvent.items = testItems
        
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return a single section containing all list items
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testEvent.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        
        UITableViewCell {
        let listItemCell = eventListTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListItemTableViewCell
        
        listItemCell.itemNameLabel.text = model.events[0].items[indexPath.row].name
        listItemCell.itemDescriptionLabel.text = model.events[0].items[indexPath.row].description
        listItemCell.itemUserLabel.text = "| Suggested by \(model.events[0].items[indexPath.row].userID) |"
            
        listItemCell.backgroundColor = UIColor.init(red: 31.0/255.0, green: 40.0/255.0, blue: 51.0/255.0, alpha: 1)
        listItemCell.itemNameLabel.textColor = UIColor.init(red: 197.0/255.0, green: 198.0/255.0, blue: 199.0/255.0, alpha: 1)
        listItemCell.itemDescriptionLabel.textColor = UIColor.init(red: 197.0/255.0, green: 198.0/255.0, blue: 199.0/255.0, alpha: 1)

        listItemCell.itemUserLabel.textColor = UIColor.init(red: 102.0/255.0, green: 252.0/255.0, blue: 241.0/255.0, alpha: 1)

        
        return listItemCell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
