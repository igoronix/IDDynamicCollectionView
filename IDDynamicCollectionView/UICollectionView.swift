//
//  UICollectionView.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

extension UICollectionReusableView: Identifiable {
    static func identifier() -> String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: Identifiable>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier(), for: indexPath) as? T else {
            fatalError("Unexpected cell type at: \(indexPath)")
        }
        
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: Identifiable>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier(), for: indexPath) as? T else {
            fatalError("Unexpected cell type at: \(indexPath)")
        }
        
        return cell
    }
}
