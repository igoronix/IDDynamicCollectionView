//
//  AlbumCell.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 8/7/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class VegetableCell: UICollectionViewCell, ConfigurableCell {
    typealias Model = Vegetable
    
    @IBOutlet private var headerLabel: UILabel!
    
    static func height(model: Model, for bounds: CGRect) -> CGFloat {
        return max(model.title.heightWithConstrainedWidth(width: bounds.width - 70, font: UIFont.systemFont(ofSize: 17)) + 50, 90)
    }
    
    func configure(model: Model) {
        headerLabel.text = model.title
    }
}
