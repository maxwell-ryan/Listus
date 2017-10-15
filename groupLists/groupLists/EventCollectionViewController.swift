//
//  EventCollectionViewController.swift
//  groupLists
//
//  Created by bergerMacPro on 10/13/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "eventCell"

var model = DataModel()
var testItems: [Item] = [Item(name: "name1", id: "id1", userID: "userID1"), Item(name: "name2", id: "id2", userID: "userID2"), Item(name: "name3", id: "id3", userID: "userID3")]
var testOrganizer = User(firstName: "John", lastName: "Doe", email: "john.doe@gmail.com", id: "1")



class EventCollectionViewController: UICollectionViewController {
    
    let backgroundImages: [UIImage] = [UIImage.init(named: "camera")!,
                                       UIImage.init(named: "coffee")!,
                                       UIImage.init(named: "concert")!,
                                       UIImage.init(named: "guitar")!,
                                       UIImage.init(named: "hallway")!,
                                       UIImage.init(named: "lightning")!,
                                       UIImage.init(named: "roadway")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //var eventController: EventController = EventController.init()
        
        //fill app model with test events
        
        //events.addEvent
        
        //events.events[idx]
        
        model.addEvent(name: "testEvent1", id: "eventID1", date: Date.init(timeIntervalSinceNow: 86400.0))
        model.addEvent(name: "testEvent2", id: "eventID2", date: Date.init(timeIntervalSinceNow: 86400.0))
        model.addEvent(name: "testEvent3", id: "eventID3", date: Date.init(timeIntervalSinceNow: 86400.0 * 2.0))
        model.addEvent(name: "testEvent4", id: "eventID4", date: Date.init(timeIntervalSinceNow: 86400.0 * 3.0))
        model.addEvent(name: "testEvent5", id: "eventID5", date: Date.init(timeIntervalSinceNow: 86400.0 * 4.0))
        model.addEvent(name: "testEvent6", id: "eventID6", date: Date.init(timeIntervalSinceNow: 86400.0 * 5.0))
        model.addEvent(name: "testEvent7", id: "eventID7", date: Date.init(timeIntervalSinceNow: 86400.0 * 6.0))
        model.addEvent(name: "testEvent8", id: "eventID8", date: Date.init(timeIntervalSinceNow: 86400.0 * 12.0))
        model.addEvent(name: "testEvent9", id: "eventID9", date: Date.init(timeIntervalSinceNow: 86400.0 * 20.0))
        model.addEvent(name: "testEvent10", id: "eventID10", date: Date.init(timeIntervalSinceNow: 86400.0 * 31.0))
        model.addEvent(name: "testEvent11", id: "eventID11", date: Date.init(timeIntervalSinceNow: 86400.0 * 90.0))
        print("EventCollectionView about to appear with \(model.events.count) events in the data model")
        
        let testOrganizer = User.init(firstName: "John", lastName: "Johnson", email: "testemail.com", id: "12")
        //fill each test event with test items
        for x in model.events {
            x.items = testItems
            x.organizer.append(testOrganizer)
            for y in x.items {
                print(y.name)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //cast cell as custom EventCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        
        //set cell background color
        if (indexPath.item % 2 == 0) {
            cell.backgroundColor = colors.primaryColor1
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        //populate custom cell with event information
        cell.eventNameLabel.text = model.events[indexPath.item].name
        cell.eventNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.eventNameLabel.textColor = UIColor.white
        
        var eventDate = model.events[indexPath.item].date
        var todayDate = Date()
        
        //format event and current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //calculate and format date interval between two dates
        var dateUntilEvent = DateInterval.init(start: todayDate, end: eventDate)
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .none
        dateIntervalFormatter.timeStyle = .short
        dateIntervalFormatter.locale = Locale(identifier: "en_US")
        
        var countdownTimeInterval = eventDate.timeIntervalSince(todayDate)
        
        cell.eventDateLabel.lineBreakMode = .byWordWrapping
        cell.eventDateLabel.numberOfLines = 0
        cell.eventDateLabel.text = "\(dateFormatter.string(from: eventDate))\nin \(convertTimeIntervalToDaysHoursMinutesSeconds(timeInterval: countdownTimeInterval))"
        cell.eventDateLabel.textColor = UIColor.white
        cell.eventDateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.eventOrganizerLabel.textColor = UIColor.white
        cell.eventOrganizerLabel.font = UIFont.systemFont(ofSize: 12)
        
        //populate image assets in background
        //generate random number no larger than number of images in image asset folder (Note: arc4random is not inclusive)
        var randomValue = arc4random_uniform(UInt32(backgroundImages.count))
        var backgroundView = UIImageView.init(image: backgroundImages[Int(randomValue)])
        cell.backgroundView = backgroundView
        
        //NOTE: ADD ORGANIZER NAME ONCE DATA MODEL INFORMATION/STRUCTURE IMPLEMENTED FULLY
        //cell.eventOrganizerLabel.text = "\(model.events[indexPath.item].organizer[0].firstName) \(model.events[indexPath.item].organizer[0].lastName)"
        
        cell.layer.borderColor = colors.accentColor1.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selected cell at path \(indexPath.item)")
        self.performSegue(withIdentifier: "displayList", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayList" {
            let selectedIndexPath = sender as! IndexPath
            let listVC = segue.destination as! ListViewController
            listVC.currentEventIdx = selectedIndexPath.item
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
