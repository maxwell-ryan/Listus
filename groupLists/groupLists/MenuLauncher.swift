//
//  MenuLauncher.swift
//  groupLists
//
//  Created by bergerMacPro on 10/18/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import UIKit

class MenuLauncher: UICollectionViewFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.menuCollectionView.dataSource = self
        self.menuCollectionView.delegate = self
        self.menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    let blurView = UIView()
    let cellID = "menuCell"
    
    let menuCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    func showMenu() {
        
        if let fullWindow = UIApplication.shared.keyWindow {
            
            blurView.backgroundColor = UIColor.black
            blurView.alpha = 0
            
            blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeMenu)))
            
            fullWindow.addSubview(blurView)
            fullWindow.addSubview(menuCollectionView)
            
            let height: CGFloat = 350
            let y = fullWindow.frame.height - height
            menuCollectionView.frame = CGRect(x: 0, y: fullWindow.frame.height, width: fullWindow.frame.width, height: height)
            
            blurView.frame = fullWindow.frame
            //blurView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurView.alpha = 0.5
                self.menuCollectionView.frame = CGRect(x: 0, y: y, width: self.menuCollectionView.frame.width, height: self.menuCollectionView.frame.height)
            } ,completion: nil)

        }
    }
    
    func closeMenu() {
        print("In close menu")
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0
            
            if let fullWindow = UIApplication.shared.keyWindow {
                self.menuCollectionView.frame = CGRect(x: 0, y: fullWindow.frame.height, width: self.menuCollectionView.frame.width, height: self.menuCollectionView.frame.height)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        cell.backgroundColor = UIColor.red
        return cell
    }
    
}
