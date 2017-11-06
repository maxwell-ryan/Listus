//
//  EventCollectionViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/13/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "eventCell"


var testItems: [Item] = [Item(name: "Backpack", id: "ID#12", userID: "USERID#34343", description: "A container to hold items", quantity: 1), Item(name: "Crock Pot", id: "ID#32", userID: "USERID#543", description: "Cookware", quantity: 1), Item(name: "Plates", id: "ID#68", userID: "USERID#99973", description: "For all attendees to eat off of...", quantity: 15), Item(name: "Gas Grill", id: "ID#8", userID: "USERID#87", description: "So we can cook the meat", quantity: 2)]


class EventCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userController : UserController!
    var userEventsController: UserEventsController!
    let navigationLauncher = NavigationLauncher()
    let menuLauncher = MenuLauncher()
    var editIdx: Int?
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var navBtn: UIButton!
    
    
    let backgroundImages: [UIImage] = [UIImage.init(named: "camera")!,
                                       UIImage.init(named: "coffee")!,
                                       UIImage.init(named: "concert")!,
                                       UIImage.init(named: "guitar")!,
                                       UIImage.init(named: "hallway")!,
                                       UIImage.init(named: "lightning")!,
                                       UIImage.init(named: "roadway")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventCollectionView.delegate = self
        self.eventCollectionView.dataSource = self

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
        
        //Create event, move to add event action
        //userEventsController.createEvent(name: "testEvent1", description: "some description", date: Date.init(timeIntervalSinceNow: 86400.0 * 60), userController: userController, eventCollectionView: eventCollectionView)
        
        userEventsController.getDBEvents(userId: userController.user.id, eventCollectionView: self.eventCollectionView)
        
        //populate menu options available from this VC
        menuLauncher.menuOptions.insert(MenuOption(name: "Add Event", iconName: "add"), at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navBtn.setTitle("", for: UIControlState.normal)
        menuBtn.setTitle("", for: UIControlState.normal)
        self.eventCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userEventsController.events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //cast cell as custom EventCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        
        //set cell background color
        if (indexPath.item % 2 == 0) {
            cell.backgroundColor = colors.primaryColor1
        } else {
            cell.backgroundColor = colors.primaryColor1
        }
        
        //populate custom cell with event information
        cell.eventNameLabel.text = userEventsController.events[indexPath.item].name
        cell.eventNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.eventNameLabel.textColor = UIColor.white
        
        let eventDate = userEventsController.events[indexPath.item].date
        let todayDate = Date()
        
        //format event and current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //calculate and format date interval between two dates, if date is still in future
        //verify the event is  in the future, then calculate, and display, countdown
        if (todayDate < eventDate) {
            let dateUntilEvent = DateInterval.init(start: todayDate, end: eventDate)
        }
        
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .none
        dateIntervalFormatter.timeStyle = .short
        dateIntervalFormatter.locale = Locale(identifier: "en_US")
        
        //verify the event is  in the future, then calculate, and display, countdown
        if (todayDate < eventDate) {
            let countdownTimeInterval = eventDate.timeIntervalSince(todayDate)
            cell.eventDateLabel.text = "\(dateFormatter.string(from: eventDate))\nin \(convertTimeIntervalToDaysHoursMinutesSeconds(timeInterval: countdownTimeInterval))"
        //otherwise notify of event expiration
        } else {
            cell.eventDateLabel.text = "This event occured on:\n\(dateFormatter.string(from: eventDate))"
        }
        cell.eventDateLabel.lineBreakMode = .byWordWrapping
        cell.eventDateLabel.numberOfLines = 0
        //cell.eventDateLabel.text = "\(dateFormatter.string(from: eventDate))\nin \(convertTimeIntervalToDaysHoursMinutesSeconds(timeInterval: countdownTimeInterval))"
        cell.eventDateLabel.textColor = UIColor.white
        cell.eventDateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.eventOrganizerLabel.textColor = UIColor.white
        cell.eventOrganizerLabel.font = UIFont.systemFont(ofSize: 12)
        
        cell.eventEditBtn.setImage(UIImage(named: "edit")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        cell.eventEditBtn.tintColor = colors.primaryColor2
        cell.eventEditBtn.tag = indexPath.item

        cell.eventEditBtn.addTarget(self, action: #selector(initiateEditEvent), for: .touchUpInside)
        //populate image assets in background
        //generate random number no larger than number of images in image asset folder (Note: arc4random is not inclusive)
        //let randomValue = arc4random_uniform(UInt32(backgroundImages.count))
        //let backgroundView = UIImageView.init(image: backgroundImages[Int(randomValue)])
        //cell.backgroundView = backgroundView
        
        //NOTE: ADD ORGANIZER NAME ONCE DATA MODEL INFORMATION/STRUCTURE IMPLEMENTED FULLY
        //cell.eventOrganizerLabel.text = "\(model.events[indexPath.item].organizer[0].firstName) \(model.events[indexPath.item].organizer[0].lastName)"

        cell.layer.borderColor = colors.accentColor1.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "displayList", sender: indexPath)
    }
    
    func initiateEditEvent(sender: UIButton){
        
        self.editIdx = sender.tag
        performSegue(withIdentifier: "editEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayList" {
            
            let selectedIndexPath = sender as! IndexPath
            let tabBarViewControllers = segue.destination as! UITabBarController
            
            let itemListVC = tabBarViewControllers.viewControllers![0] as! ItemListViewController
            itemListVC.currentEventIdx = selectedIndexPath.item
            itemListVC.userEventsController = self.userEventsController
            itemListVC.userController = self.userController
            
            let messagingVC = tabBarViewControllers.viewControllers![1] as! MessagingViewController
            messagingVC.eventId = userEventsController.events[selectedIndexPath.item].id
            messagingVC.userEventsController = self.userEventsController
            messagingVC.userController = self.userController
        
        } else if segue.identifier == "addEvent" {
            
            let destinationVC = segue.destination as! EventViewController
            destinationVC.userController = self.userController
            destinationVC.userEventsController = self.userEventsController
        
        } else if segue.identifier == "editEvent" {
            
            let destinationVC = segue.destination as! EventViewController
            destinationVC.userController = self.userController
            destinationVC.userEventsController = self.userEventsController
            destinationVC.editIdx = self.editIdx
        }
    }
    
    func convertTimeIntervalToDaysHoursMinutesSeconds(timeInterval: TimeInterval) -> String {
        
        let totalSeconds = Int(timeInterval)
        
        let seconds = totalSeconds % 60
        var minutes = totalSeconds % 3600
        minutes = minutes / 60
        let hours = totalSeconds / 3600
        
        if (hours <= 24) {
            return "\(hours) hrs. \(minutes) min. \(seconds) sec"
        } else {
            let days = (totalSeconds / 86400)
            
            if (days == 1) {
                return "\(days) day"
            } else {
               return "\(days) days"
            }
        }
    }
    
    func displayMenu() {
        
        menuLauncher.baseEventCollectionVC = self
        menuLauncher.showMenu()
    }
    
    func executeMenuOption(option: MenuOption) {
        
        if option.name == "Cancel" {
            //cancel selected, do nothing
        } else if option.name == "Add Event" {
            //add requested, fire add event
            performSegue(withIdentifier: "addEvent", sender: self)
        }
    }
    
    func displayNav() {
        
        navigationLauncher.baseEventCollectionVC = self
        navigationLauncher.showMenu()
    }
    
    func executeNavOption(option: NavOption) {
        
        if option.name == "Cancel" {
            //cancel selected, do nothing
        }
        else if option.name == "My Events" {
            //do nothing - already at events view
 
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
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
