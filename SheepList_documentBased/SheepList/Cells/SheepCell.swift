//
//  SheepCell.swift
//  SheepList
//
//  Created by Andreas Våge on 21.06.2017.
//
//

import UIKit

class SheepCell: UITableViewCell {
    
    @IBOutlet weak var SheepIDLabel: PaddingLabel!
    @IBOutlet weak var LambStackView: UIStackView!
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 3.0
    @IBInspectable var rightInset: CGFloat = 3.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}


