//
//  SectionBuilder.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 8/2/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol ConfigurableCell: Associated {
    static func height(model: Model, for bounds: CGRect) -> CGFloat
    func configure(model: Model)
}

protocol ConfigurableHeader {
    func configure(sectionBuilder: SectionBuilder)
    static func height(model: SectionBuilder, for bounds: CGRect) -> CGFloat
}

protocol SectionBuilder: class {
    var reuseableHeaderId: String { get }
    var rowBuilders: [RowBuilder] { get }
    var expandable: Bool { get }
    var title: String { get }
    func configure(header: UICollectionReusableView)
    func headerHeight(for bounds: CGRect) -> CGFloat
}

class CollectionSectionBuilder <HeaderViewType: UICollectionReusableView>: SectionBuilder where HeaderViewType: ConfigurableHeader {
    var rowBuilders: [RowBuilder] = []
    var title: String
    
    var reuseableHeaderId: String {
        return String(describing: HeaderViewType.identifier())
    }
    
    var expandable: Bool {
        return HeaderViewType() is TouchableHeader
    }
    
    init(title: String) {
        self.title = title
    }
    
    func configure(header: UICollectionReusableView) {
        (header as? HeaderViewType)?.configure(sectionBuilder: self)
    }
    
    func headerHeight(for bounds: CGRect) -> CGFloat {
        return HeaderViewType.height(model: self, for: bounds)
    }
}
