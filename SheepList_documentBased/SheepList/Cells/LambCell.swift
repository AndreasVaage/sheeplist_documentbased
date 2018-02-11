//
//  LambCell.swift
//  SheepList
//
//  Created by Andreas Våge on 29.06.2017.
//
//
import UIKit

class LambCell: UITableViewCell {
    
    @IBOutlet weak var lambIDTextField: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    
    // Done buttton
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(LambCell.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.lambIDTextField.inputAccessoryView = doneToolbar
        
        let item = self.lambIDTextField.inputAssistantItem
        item.leadingBarButtonGroups = []
        //let group = UIBarButtonItemGroup()
        //group.barButtonItems = [done]
        item.trailingBarButtonGroups = []
        
    }
    
    @objc func doneButtonAction()
    {
        self.lambIDTextField.resignFirstResponder()
    }
}
