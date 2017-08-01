//
//  CustomFlowLayout.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/24/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

open class CustomFlowLayout: UICollectionViewFlowLayout {
    fileprivate var insertedIndexPaths: [IndexPath]?
    fileprivate var deletedIndexPaths: [IndexPath]?
    
    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertedIndexPaths = updateItems.filter({ $0.updateAction == .insert }).map { $0.indexPathAfterUpdate! }
        deletedIndexPaths = updateItems.filter({ $0.updateAction == .delete }).map { $0.indexPathBeforeUpdate! }
    }
    
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertedIndexPaths = nil
        deletedIndexPaths = nil
    }
    
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at: itemIndexPath).map {
            if let insertedIndexPaths = insertedIndexPaths, insertedIndexPaths.contains(itemIndexPath) {
                $0.transform = CGAffineTransform(translationX: 0, y: -100)
                $0.alpha = 0.0
            }
            return $0
        }
    }
    
    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at: itemIndexPath).map {
            if let deletedIndexPaths = deletedIndexPaths, deletedIndexPaths.contains(itemIndexPath) {
                $0.transform = CGAffineTransform(translationX: 0.0, y: -100.0).concatenating(CGAffineTransform(scaleX: 100, y: 1))
                $0.alpha = 0.0
            }
            return $0
        }
    }
}
