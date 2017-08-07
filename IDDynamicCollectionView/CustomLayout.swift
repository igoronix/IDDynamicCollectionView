//
//  CustomLayout.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/19/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate: class {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForSection section: Int) -> CGFloat
}

let kDamping: CGFloat = 1.0
let kFrequence: CGFloat = 1.5
let kResistence: CGFloat = 0.05

class CustomLayout: UICollectionViewLayout {
    weak var delegate: CustomLayoutDelegate!
    
    var itemsPadding: CGFloat = 1
    
    private var numberOfColumns = 1
    private var cacheAttributes = [UICollectionViewLayoutAttributes]()
    
    private var sectionHeights = [Int : CGFloat]()
    
    private var expandedPaths = [IndexPath]()
    private var collapsedPaths = [IndexPath]()
    
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    private lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(collectionViewLayout: self)
    }()
    
    
    override init() {
        super.init()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChangeNotification), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overrided methods
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: width, height: contentHeight)
        }
    }
    
    override func invalidateLayout() {
        
        self.contentHeight = 0
        self.cacheAttributes.removeAll()
        self.sectionHeights.removeAll()
        
        super.invalidateLayout()
    }
    
    func orientationDidChangeNotification() {
        DispatchQueue.main.async {
            self.dynamicAnimator.removeAllBehaviors()
            self.collectionView?.reloadData()
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func prepare() {
        super.prepare()
        
        let columnWidth = width / CGFloat(numberOfColumns)
        var xOffxets = [CGFloat]()
        
        for column in 0..<numberOfColumns {
            xOffxets.append(CGFloat(column) * columnWidth)
        }
        
        var yOffxets = [CGFloat](repeating: 0, count: numberOfColumns)
        var column = 0
        
        let totalSectionCount = collectionView!.numberOfSections
        var currentRow = 0
        for section in 0..<totalSectionCount {
            let headerHeight = self.delegate.collectionView(collectionView: collectionView!, heightForSection: section)
            if headerHeight > 0 {
                let headerIndexPath = IndexPath(item:0, section:section)
                let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: headerIndexPath)
                let frame = CGRect(x: xOffxets[column], y: yOffxets[column], width: columnWidth, height: headerHeight)
                headerAttr.frame = frame
                headerAttr.zIndex = section
                cacheAttributes.append(headerAttr)
                contentHeight = max(contentHeight, frame.maxY)
                yOffxets[column] = yOffxets[column] + headerHeight + itemsPadding
            }
            sectionHeights[section] = headerHeight
            
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                currentRow -= 1
                let indexPath = IndexPath(item: item, section: section)
                let height = self.delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
                let frame = CGRect(x: xOffxets[column], y: yOffxets[column], width: columnWidth, height: height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                attributes.zIndex = currentRow
                
                cacheAttributes.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffxets[column] = yOffxets[column] + height + itemsPadding
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
        
        if cacheAttributes.count != self.dynamicAnimator.behaviors.count {
            self.dynamicAnimator.removeAllBehaviors()
            cacheAttributes.forEach({ (attributes) in
                let springBehaviour: UIAttachmentBehavior = UIAttachmentBehavior(item: attributes as UIDynamicItem, attachedToAnchor: attributes.center)
                self.dynamicAnimator.addBehavior(springBehaviour, kDamping, kFrequence)
            })
        }
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        self.expandedPaths = []
        self.collapsedPaths = []
        
        updateItems.forEach {
            if let path = $0.indexPathAfterUpdate {
                self.expandedPaths.append(path)
            }
            else if let path = $0.indexPathBeforeUpdate {
                self.collapsedPaths.append(path)
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if self.expandedPaths.contains(itemIndexPath) {
            let headerHeight = self.sectionHeights[itemIndexPath.section] ?? 0
            attributes?.transform = CGAffineTransform(translationX: 0, y: -headerHeight)
            attributes?.alpha = 0
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if self.collapsedPaths.contains(itemIndexPath) {
            let headerHeight = self.sectionHeights[itemIndexPath.section] ?? 0
            attributes?.transform = CGAffineTransform(translationX: 0, y: -headerHeight)
            attributes?.alpha = 0.0
        }
        
        return attributes
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        self.expandedPaths.removeAll()
        self.collapsedPaths.removeAll()
        self.dynamicAnimator.removeAllBehaviors()
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        self.dynamicAnimator.behaviors.flatMap { $0 as? UIAttachmentBehavior }.forEach {
            guard let view = collectionView, let item = $0.items.first else { return }
            update(behavior: $0, and: item, in: view, for: newBounds)
            self.dynamicAnimator.updateItem(usingCurrentState: item)
        }
        return !newBounds.size.equalTo(collectionView!.frame.size)
    }
    
    //MARK: - Private
    
    private func update(behavior: UIAttachmentBehavior, and item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x, dy: bounds.origin.y - view.bounds.origin.y)
        let resistance = CGVector(dx: fabs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / 1000, dy: fabs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / 1000)
        item.center.y += delta.dy < 0 ? max(delta.dy, delta.dy * resistance.dy) : min(delta.dy, delta.dy * resistance.dy)
        item.center.x += delta.dx < 0 ? max(delta.dx, delta.dx * resistance.dx) : min(delta.dx, delta.dx * resistance.dx)
    }
}

extension UIDynamicAnimator {
    open func addBehavior(_ behavior: UIAttachmentBehavior, _ damping: CGFloat, _ frequency: CGFloat) {
        behavior.damping = damping
        behavior.frequency = frequency
        addBehavior(behavior)
    }
}
