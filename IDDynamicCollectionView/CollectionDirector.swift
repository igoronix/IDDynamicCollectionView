//
//  CollectionDirector.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 8/2/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class CollectionDirector: NSObject {
    fileprivate weak var collectionView: UICollectionView?
    fileprivate var expandedSections: Array<Int> = []
    fileprivate var builders = [SectionBuilder]()
    
    init(collectionView: UICollectionView) {
        super.init()
        
        collectionView.dataSource = self
        self.collectionView = collectionView
    }
    
    func append(sectionBuilder: SectionBuilder) {
        builders.append(sectionBuilder)
        
        sectionBuilder.rowBuilders.forEach { builder in
            collectionView?.register(UINib(nibName: builder.reuseableId, bundle: nil), forCellWithReuseIdentifier: builder.reuseableId)
        }
        
        collectionView?.register(UINib(nibName: sectionBuilder.reuseableHeaderId, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionBuilder.reuseableHeaderId)
    }
    
    fileprivate func indexPathsForRowsInSection(_ section: Int) -> [IndexPath] {
        var result: Array<IndexPath> = []
        builders[section].rowBuilders.forEach { builder in
            for row in result.count..<builder.itemsCount+result.count {
                result.append(IndexPath.init(item: row, section: section))
            }
        }
        return result
    }
}

extension CollectionDirector: CustomLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        var currentRowIndex = indexPath.row
        
        for builderIndex in 0...self.builders[indexPath.section].rowBuilders.count {
            let rowBuilder = self.builders[indexPath.section].rowBuilders[builderIndex]
            if (currentRowIndex - rowBuilder.itemsCount + 1) <= 0 {
                return rowBuilder.heightForCell(itemIndex: currentRowIndex, bounds: collectionView.bounds)
            } else {
                currentRowIndex -= rowBuilder.itemsCount
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForSection section: Int) -> CGFloat {
        return self.builders[section].headerHeight(for: collectionView.bounds)
    }
}

extension CollectionDirector: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.builders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionBuilder = self.builders[section]
        return expandedSections.contains(section) || !sectionBuilder.expandable ? self.builders[section].rowBuilders.map({$0.itemsCount}).reduce(0, { x, y in x + y }) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionBuilder = self.builders[indexPath.section]
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionBuilder.reuseableHeaderId, for: indexPath)
        sectionBuilder.configure(header: view)
        
        if let cell = view as? TouchableHeader {
            cell.delegate = self
            cell.isHighlighted = expandedSections.contains(indexPath.section)
        }
        return view 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell? = nil
        var currentRowIndex = indexPath.row
        
        for builderIndex in 0...self.builders[indexPath.section].rowBuilders.count {
            let rowBuilder = self.builders[indexPath.section].rowBuilders[builderIndex]
            if (currentRowIndex - rowBuilder.itemsCount + 1) <= 0 {
                
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowBuilder.reuseableId, for: indexPath)
                rowBuilder.configure(cell: cell, itemIndex: currentRowIndex)
                break
            } else {
                currentRowIndex -= rowBuilder.itemsCount
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
}


extension CollectionDirector : HeaderViewDelegate {
    func didSelectHeader(_ headerView: TouchableHeader) {

        let sectionItems = self.indexPathsForRowsInSection(headerView.tag) as [IndexPath]
        let isExpand = self.expandedSections.index(of: headerView.tag) == nil
        headerView.isHighlighted = isExpand

        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.05, options: [.curveEaseInOut], animations: {
            if let index = self.expandedSections.index(of: headerView.tag) {
                self.expandedSections.remove(at: index)
                self.collectionView?.deleteItems(at: sectionItems)
            } else {
                self.expandedSections.append(headerView.tag)
                self.collectionView?.insertItems(at: sectionItems)
            }
        }, completion: { (finished) in
            if let firstItem = sectionItems.first, isExpand {
                self.collectionView?.scrollToItem(at: firstItem, at: .centeredVertically, animated: true)
            }
        })
    }
}
