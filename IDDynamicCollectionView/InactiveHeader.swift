//
//  HeaderView2.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 8/7/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class InactiveHeader: UICollectionReusableView, ConfigurableHeader {

    @IBOutlet private var headerLabel: UILabel!
    
    func configure(sectionBuilder: SectionBuilder) {
        headerLabel.text = sectionBuilder.title
    }
    
    static func height(model: SectionBuilder, for bounds: CGRect) -> CGFloat {
        return 44
    }
}
