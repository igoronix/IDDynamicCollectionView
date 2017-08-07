//
//  Protocols.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/28/17.
//  Copyright © 2017 ID. All rights reserved.
//

import UIKit

protocol Associated {
    associatedtype Model
}

protocol NibLoadable {
    static func nibView<T: UIView>(viewType type: T.Type) -> T?
}

protocol Identifiable {
    static func identifier() -> String
}
