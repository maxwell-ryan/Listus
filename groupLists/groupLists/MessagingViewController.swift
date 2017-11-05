//
//  MessagingViewController.swift
//  groupLists
//
//  Created by Kyle Cross on 11/4/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change send button color to blue
        let origImage = UIImage(named: "ic_send_3x")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(tintedImage, for: .normal)
        sendButton.tintColor = .blue
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
