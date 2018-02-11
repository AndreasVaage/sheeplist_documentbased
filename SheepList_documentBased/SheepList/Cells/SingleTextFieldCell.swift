//
//  SingleTextFieldCell.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 10.02.2018.
//  Copyright © 2018 Andreas Våge. All rights reserved.
//

import UIKit

class SingleTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    // Done buttton
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EditSheepTableViewCell.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
        
        let item = self.textField.inputAssistantItem
        item.leadingBarButtonGroups = []
        //let group = UIBarButtonItemGroup()
        //group.barButtonItems = [done]
        item.trailingBarButtonGroups = []
        
    }
    
    @objc func doneButtonAction()
    {
        self.textField.resignFirstResponder()
    }

}
