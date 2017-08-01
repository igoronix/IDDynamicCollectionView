//
//  TableViewController.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/17/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

enum TableViewlayout {
    case Custom
    case Flow
}

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    lazy var customLayout: CustomLayout = {
        let layout = CustomLayout()
        layout.delegate = self

        return layout
    }()
    
    var expandedSections: Array<Int> = []
    
    let data = [["title" : "Header 1 \neffjxcx",
                 "items" : ["kjnjnkdf \n efgdfgdgf", "wedewd", "wddwdw"]],
                ["title" : "Header 2 fjfjggf \n efjegrjgejger \negjieregiu",
                 "items" : ["wdndnw \nkfjefg \nsfog", "dede ndfjhgdfi h  fgjhgdfhjgdfjhkgfdwe", "dwdwdw", "dwdwwddw", "dwdww\ndwd"]],
                ["title" : "Header 3 lkeijgfiogngdf ffg fg fg ifgdiuofgdioufg fg fg gfiodfgiodfgiodfgiodfg fdg fgd fdgifdgiofdgio",
                 "items" : ["wdddwd", "dwwdd vjkvjkdvjklgdfjkl gdf jjklgfd\nwd", "dwdwdwdw", "dwdwwdd hfjhgafhjgj jk gjhk\n\ngfdjk wdwdw", "wddwdwdeedwe", "dwwd djkdkjlgdfj  jlgjkl wd"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = self.customLayout
        
        self.collectionView.register(UINib.init(nibName: CollectionReusableView.identifier(), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier())

        self.collectionView.bounces = true
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.delegate = self
    }
    
    func indexPathsForRowsInSection(_ section: Int) -> [NSIndexPath] {
        let sect = data[section]
        if let items = sect["items"] as? Array<String> {
            return (0..<items.count).map{ NSIndexPath(row: $0, section: section) }
        }
        return []
    }
    
    @IBAction func selectHeader(_ sender: Any) {
        if let gestureRecognizer = sender as? UIGestureRecognizer {
            if let view = gestureRecognizer.view as? CollectionReusableView {
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
    }
}

extension CollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.expandedSections.contains(indexPath.section) ? CGSize(width:self.view.bounds.width, height: 100) : CGSize(width:self.view.bounds.width, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize(width: self.view.bounds.width, height: 0)
        let sectionData = data[section]
        
        if let title = sectionData["title"] as? String {
            size.height = title.heightWithConstrainedWidth(width: size.width - 10, font: UIFont.systemFont(ofSize: 17)) + 10
        }
        
        return size
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sect = data[section]
        if let items = sect["items"] as? Array<String>, expandedSections.contains(section) {
            return items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: CollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        
        let sectionData = data[indexPath.section]
        view.headerLabel.text = sectionData["title"] as? String
        view.tag = indexPath.section
        view.isHighlighted = expandedSections.contains(indexPath.section)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectHeader(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        let sectionData = data[indexPath.section]
        let cellDataItems = sectionData["items"] as? Array<String>
        cell.headerLabel.text = cellDataItems?[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        cell.contentView.backgroundColor = UIColor.cyan
        return cell
    }
}

extension CollectionViewController : CustomLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if let d = data[indexPath.section] as? Dictionary<String, Any> {
            if let array = d["items"] as? Array<String> {
                return CollectionViewCell.heightWithData(array[indexPath.item], for: self.view.bounds)
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForSection section: Int) -> CGFloat {
        var size = CGSize(width: self.view.bounds.width, height: 0)
        let sectionData = data[section]
        
        if let title = sectionData["title"] as? String {
            size.height = title.heightWithConstrainedWidth(width: size.width - 10, font: UIFont.systemFont(ofSize: 17)) + 10
        }
        
        return size.height
    }
}
