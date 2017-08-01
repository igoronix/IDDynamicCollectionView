//
//  String.swift
//  IDDynamicCollectionView
//
//  Created by Igor Dorofix on 7/18/17.
//  Copyright © 2017 ID. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var length: Int {
        return self.characters.count
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options:  NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func requiredHeightForLabel(width: CGFloat, font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        if lineSpacing > 0.0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = .left
            label.attributedText = NSAttributedString(string: self, attributes: [NSParagraphStyleAttributeName: style, NSFontAttributeName: font])
        } else {
            label.text = self
        }
        label.sizeToFit()
        return label.frame.height
        
    }    
}
