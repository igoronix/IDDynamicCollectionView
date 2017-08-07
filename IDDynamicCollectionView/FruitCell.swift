//
//  CollectionViewCell.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class FruitCell: UICollectionViewCell, ConfigurableCell {
    typealias Model = Fruit

    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    
    static func height(model: Model, for bounds: CGRect) -> CGFloat {
        return max(model.title.heightWithConstrainedWidth(width: bounds.width - 70, font: UIFont.systemFont(ofSize: 17)) + 50, 90)
    }

    
    func configure(model: Model) {
        self.headerLabel.text = model.title
    }
}
