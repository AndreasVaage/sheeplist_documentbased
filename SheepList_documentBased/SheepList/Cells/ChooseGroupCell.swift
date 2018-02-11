//
//  ChooseGroupCellTableViewCell.swift
//  SheepList
//
//  Created by Andreas Våge on 03.12.2017.
//

import UIKit

class ChooseGroupCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }
}
