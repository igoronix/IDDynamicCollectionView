//
//  TableViewController.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/17/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var sections:[SectionModel] = []
    var collectionView: UICollectionView!
    
    lazy var customLayout: CustomLayout = {
        let layout = CustomLayout()
        layout.delegate = self
        return layout
    }()
    
    var expandedSections: Array<Int> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: customLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: customLayout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let model = SectionModel()
        model.title = "section 0"
        let item = ItemModel()
        item.title = "Item0"
        
        let item1 = ItemModel()
        item.title = "Item1"

        let item2 = ItemModel()
        item.title = "Item2"

        model.items.append(item)
        model.items.append(item1)
        model.items.append(item2)
        sections.append(model)

        
        let model1 = SectionModel()
        model1.title = "section 1"
        model1.items.append(item)
        model1.items.append(item1)
        sections.append(model1)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = self.customLayout
        collectionView.backgroundColor = UIColor.lightGray

        self.view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute:.bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        self.collectionView.register(UINib(nibName: HeaderView.identifier(), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderView.identifier())
        self.collectionView.register(UINib(nibName: CollectionViewCell.identifier(), bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier())
    }
    
    func indexPathsForRowsInSection(_ section: Int) -> [IndexPath] {
        return (0..<sections[section].items.count).map{ IndexPath(row: $0, section: section) }
    }
}

extension CollectionViewController : HeaderViewDelegate {
    func didSelectHeader(_ headerView: UICollectionReusableView) {
        guard let view = headerView as? HeaderView else {
            return
        }
        
        let sectionItems = self.indexPathsForRowsInSection(view.tag) as [IndexPath]
        let isExpand = self.expandedSections.index(of: view.tag) == nil
        view.isHighlighted = isExpand
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.05, options: [.curveEaseInOut], animations: {
            if let index = self.expandedSections.index(of: view.tag) {
                self.expandedSections.remove(at: index)
                self.collectionView.deleteItems(at: sectionItems)
            } else {
                self.expandedSections.append(view.tag)
                self.collectionView.insertItems(at: sectionItems)
            }
        }, completion: { (finished) in
            if let firstItem = sectionItems.first, isExpand {
                self.collectionView.scrollToItem(at: firstItem, at: .centeredVertically, animated: true)
            }
        })
    }
}

extension CollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.expandedSections.contains(indexPath.section) ? CGSize(width:self.view.bounds.width, height: 100) : CGSize(width:self.view.bounds.width, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize(width: self.view.bounds.width, height: 0)
        let sectionData = sections[section]
        size.height = sectionData.title.heightWithConstrainedWidth(width: size.width - 20, font: UIFont.systemFont(ofSize: 17)) + 10
        
        return size
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if expandedSections.contains(section) {
            return sections[section].items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: HeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        
        let sectionData = sections[indexPath.section]
        view.headerLabel.text = sectionData.title
        view.tag = indexPath.section
        view.isHighlighted = expandedSections.contains(indexPath.section)
        view.delegate = self
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let sectionData = sections[indexPath.section]
        
        cell.headerLabel.text = sectionData.items[indexPath.row].title
        cell.descriptionLabel.text = sectionData.items[indexPath.row].description
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension CollectionViewController : CustomLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let sectionData = sections[indexPath.section]
        return CollectionViewCell.heightWithData(sectionData.items[indexPath.row].title, for: self.view.bounds)
    }
    
    func collectionView(collectionView: UICollectionView, heightForSection section: Int) -> CGFloat {
        var size = CGSize(width: self.view.bounds.width, height: 0)
        let sectionData = sections[section]
        size.height = sectionData.title.heightWithConstrainedWidth(width: size.width - 10, font: UIFont.systemFont(ofSize: 17)) + 10
        
        return size.height
    }
}
