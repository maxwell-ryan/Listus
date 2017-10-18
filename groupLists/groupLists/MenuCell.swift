//
//  MenuCell.swift
//  groupLists
//
//  Created by bergerMacPro on 10/18/17.
//  Copyright © 2017 bergerMacPro. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createCellView() {
        self.backgroundColor = UIColor.red
    }
    
}
