//
//  ListViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/9/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userController: UserController!
    var userEventsController: UserEventsController!
    var eventItemsController = EventItemsController()
    var currentEventIdx: Int! //unwrapped optional required to prevent Xcode mandating this class have an initializer - let's discuss best practice, I am unsure
    
    let navigationLauncher = NavigationLauncher()
    let menuLauncher = MenuLauncher()
    
    @IBOutlet weak var addListItemBtn: UIButton!
    @IBOutlet weak var listItemTableView: UITableView!

    @IBOutlet weak var listInfoLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var navBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listItemTableView.dataSource = self
        listItemTableView.delegate = self
        
        listItemTableView.backgroundColor = colors.primaryColor1
        
        listItemTableView.reloadData()
        
        self.view.backgroundColor = UIColor.white  //colors.primaryColor1
        
        addListItemBtn.setTitleColor(colors.accentColor1, for: UIControlState.normal)
        addListItemBtn.backgroundColor = colors.primaryColor2
        addListItemBtn.layer.cornerRadius = 10
        addListItemBtn.addTarget(self, action: #selector(newItemSegue), for: UIControlEvents.touchUpInside)
        addListItemBtn.isHidden = true
        
        navBtn.setImage(UIImage(named: "menu2x"), for: UIControlState.normal)
        navBtn.showsTouchWhenHighlighted = true
        navBtn.tintColor = UIColor.darkGray
        navBtn.addTarget(self, action: #selector(displayNav), for: .touchUpInside)
        
        menuBtn.setImage(UIImage(named: "filledmenu"), for: UIControlState.normal)
        menuBtn.showsTouchWhenHighlighted = true
        menuBtn.setImage(UIImage(named: "menu"), for: UIControlState.highlighted)
        menuBtn.showsTouchWhenHighlighted = true
        menuBtn.tintColor = UIColor.black
        self.view.addConstraint(NSLayoutConstraint(item: menuBtn, attribute: .centerY, relatedBy: .equal, toItem: navBtn, attribute: .centerY, multiplier: 1, constant: 0))
        menuBtn.addTarget(self, action: #selector(displayMenu), for: .touchUpInside)
        
        listInfoLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listInfoLabel.text = "Organized by \("John") \("Williams")    |    \(eventItemsController.items.count) items suggested"
        
        listNameLabel.textColor = UIColor.init(red: 11.0/255.0, green: 12.0/255.0, blue: 16.0/255.0, alpha: 1)
        listNameLabel.text = userEventsController.events[currentEventIdx].name
        
        //add contextual options to bottom fly-in menu bar
        menuLauncher.menuOptions.insert(MenuOption(name: "Back", iconName: "back"), at: 0)
        menuLauncher.menuOptions.insert(MenuOption(name: "Add", iconName: "add"), at: 1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        listItemTableView.reloadData()
        print("ListViewController scoped on event idx: \(currentEventIdx!)")
        
        navBtn.setTitle("", for: UIControlState.normal)
        menuBtn.setTitle("", for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newItemSegue() {
        performSegue(withIdentifier: "addItem", sender: self)
    }
    
    
    //implement UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItemsController.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let listItemCell = listItemTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListItemTableViewCell
            
            listItemCell.itemNameLabel.text = eventItemsController.items[indexPath.row].name
            listItemCell.itemDescriptionLabel.text = eventItemsController.items[indexPath.row].description
            listItemCell.itemUserLabel.text = "| Suggested by \(eventItemsController.items[indexPath.row].userID) |"
            
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
            let destinationVC = segue.destination as! ItemViewController
            
            destinationVC.userEventsController = self.userEventsController
            destinationVC.id = self.userController.user.id
            destinationVC.userID = self.userController.user.id
            destinationVC.eventItemsController = self.eventItemsController
            
            //maintain current event scope/idx
            destinationVC.currentEventIdx = self.currentEventIdx
            destinationVC.editIdx = selectedRow.tag
            print("In prepare sugue, currentEventIdx is scoped on: \(currentEventIdx)")

        } else if segue.identifier == "addItem" {
            
            let destinationVC = segue.destination as! ItemViewController
            destinationVC.currentEventIdx = self.currentEventIdx
            destinationVC.userEventsController = self.userEventsController
            destinationVC.id = self.userController.user.id
            destinationVC.userID = self.userController.user.id
            destinationVC.eventItemsController = self.eventItemsController
        
        } else if segue.identifier == "returnToEvents" {
            
            let destinationVC = segue.destination as! EventCollectionViewController
            destinationVC.userEventsController = self.userEventsController
            destinationVC.userController = self.userController
        }
    }
    
    func displayMenu() {
        
        menuLauncher.baseItemListVC = self
        menuLauncher.showMenu()
    }
    
    func executeMenuOption(option: MenuOption) {
        
        if option.name == "Cancel" {
           //cancel selected, do nothing
        } else if option.name == "Back" {
            //back requested, inititate back segue
            performSegue(withIdentifier: "returnToEvents", sender: self)
        } else if option.name == "Add" {
            //add requested, fire add event
            addListItemBtn.sendActions(for: .touchUpInside)
        }
    }
    
    func displayNav() {
        
        navigationLauncher.baseItemListVC = self
        navigationLauncher.showMenu()
    }
    
    func executeNavOption(option: NavOption) {
        
        if option.name == "Cancel" {
            //cancel selected, do nothing
        }
        else if option.name == "My Events" {
            //go to events view
            performSegue(withIdentifier: "returnToEvents", sender: self)
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
