//
//  TableViewController.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/17/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    public var director: CollectionDirector!
    
    lazy var customLayout: CustomLayout = {
        let layout = CustomLayout()
        return layout
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: customLayout)
        self.director = CollectionDirector(collectionView: self.collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: customLayout)
        self.director = CollectionDirector(collectionView: self.collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customLayout.delegate = self.director
        
        let sectionBuilder1 = CollectionSectionBuilder<HeaderView>(title: "First basket")
        let rowsFruits1 = CollectionRowBuider<Fruit, FruitCell>(items: [Fruit(title: "Orange"), Fruit(title: "Apple"), Fruit(title: "Melon")])
        let rowsVegetables1 = CollectionRowBuider<Vegetable, VegetableCell>(items: [Vegetable(title: "Onion"), Vegetable(title: "Potato"), Vegetable(title: "Cabbage")])
        let rowsFruits12 = CollectionRowBuider<Fruit, FruitCell>(items: [Fruit(title: "Peach"), Fruit(title: "Appricot")])

        sectionBuilder1.rowBuilders.append(rowsFruits1)
        sectionBuilder1.rowBuilders.append(rowsVegetables1)
        sectionBuilder1.rowBuilders.append(rowsFruits12)
        
        let sectionBuilder2 = CollectionSectionBuilder<InactiveHeader>(title: "Second basket")
        let rowsFruits2 = CollectionRowBuider<Fruit, FruitCell>(items: [Fruit(title: "Bannana"), Fruit(title: "Grape"), Fruit(title: "Pear")])
        sectionBuilder2.rowBuilders.append(rowsFruits2)

        director.append(sectionBuilder: sectionBuilder1)
        director.append(sectionBuilder: sectionBuilder2)
        
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
    }
}
