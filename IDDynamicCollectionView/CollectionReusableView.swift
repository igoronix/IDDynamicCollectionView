//
//  CollectionReusableView.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    @IBOutlet var headerLabel: UILabel!
    
    var isHighlighted: Bool = false {
        didSet {
            self.backgroundColor = self.isHighlighted ? UIColor.lightGray : UIColor.white
        }
    }
}

