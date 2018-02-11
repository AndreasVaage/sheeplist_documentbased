//
//  SingleSheepCell.swift
//  SheepList
//
//  Created by Andreas Våge on 08.08.2017.
//
//

import UIKit

class SingleSheepCell: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}
