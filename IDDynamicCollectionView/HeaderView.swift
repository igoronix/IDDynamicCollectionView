//
//  CollectionReusableView.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didSelectHeader(_ headerView: UICollectionReusableView)
}

class HeaderView: UICollectionReusableView, NibLoadable {
    @IBOutlet var headerLabel: UILabel!
    weak var delegate: HeaderViewDelegate?
    
    var isHighlighted: Bool = false {
        didSet {
            self.backgroundColor = self.isHighlighted ? UIColor.darkGray : UIColor.gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectHeader(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func selectHeader(_ sender: Any) {
        self.delegate?.didSelectHeader(self)
    }
}

