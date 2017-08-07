//
//  CollectionReusableView.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didSelectHeader(_ headerView: TouchableHeader)
}

protocol TouchableHeader: class {
    var tag: Int {get set}
    var isHighlighted: Bool {get set}
    var delegate:HeaderViewDelegate? {get set}
}

class HeaderView: UICollectionReusableView, NibLoadable, TouchableHeader, ConfigurableHeader {
    @IBOutlet private var headerLabel: UILabel!
    
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
    
    func configure(sectionBuilder: SectionBuilder) {
        self.headerLabel.text = sectionBuilder.title
    }
    
    static func height(model: SectionBuilder, for bounds: CGRect) -> CGFloat {
        return model.title.heightWithConstrainedWidth(width: bounds.width-20, font: UIFont.systemFont(ofSize: 17)) + 30
    }
}
