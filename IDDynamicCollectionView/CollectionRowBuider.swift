//
//  RowBuilder.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 8/7/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol RowBuilder {
    var reuseableId: String { get }
    var itemsCount: Int { get }
    func configure(cell: UICollectionViewCell?, itemIndex: Int)
    func heightForCell(itemIndex: Int, bounds: CGRect) -> CGFloat
}

class CollectionRowBuider<ItemType, CellType: UICollectionReusableView>: RowBuilder where CellType: ConfigurableCell, CellType.Model == ItemType {
    
    private var items = [ItemType]()
    
    var reuseableId: String {
        return String(describing: CellType.identifier())
    }
    
    var itemsCount: Int {
        return self.items.count
    }
    
    init(items: [ItemType]) {
        self.items = items
    }
    
    func heightForCell(itemIndex: Int, bounds: CGRect) -> CGFloat {
        return CellType.height(model: items[itemIndex], for: bounds)
    }
    
    func configure(cell: UICollectionViewCell?, itemIndex: Int) {
        (cell as? CellType)?.configure(model: items[itemIndex])
    }
}
