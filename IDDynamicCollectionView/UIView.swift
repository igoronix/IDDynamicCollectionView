//
//  UIView.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/28/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

extension NibLoadable where Self: UIView {
    static func nibView<T: UIView>(viewType type: T.Type) -> T? {
        return Bundle.main.loadNibNamed(String(describing: type), owner:nil, options: nil)?.first as? T
    }
    
    static func nibView() -> Self? {
        return nibView(viewType: self)
    }
}
