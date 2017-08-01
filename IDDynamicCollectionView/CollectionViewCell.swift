//
//  CollectionViewCell.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    static func heightWithData(_ data: String, for bounds: CGRect) -> CGFloat {
        return max(data.heightWithConstrainedWidth(width: bounds.width - 70, font: UIFont.systemFont(ofSize: 17)) + 50, 90)
    }    
}
