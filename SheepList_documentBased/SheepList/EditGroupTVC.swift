//
//  EditGroupTVC.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 10.02.2018.
//  Copyright © 2018 Andreas Våge. All rights reserved.
//

import UIKit

protocol EditGroupTVCDelegate {
    func changedGroup(to newGroup: Group)
}

class EditGroupTVC: UITableViewController {
    var delegate: EditGroupTVCDelegate?
    var group: Group?
    
    let titleSection = 0
    let colorSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case titleSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldCell", for: indexPath) as! SingleTextFieldCell
            
            cell.textField.text = group?.title
            cell.textField.textColor = group?.color
            cell.addDoneButtonOnKeyboard()
            cell.textField.delegate = self
            return cell
        case colorSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleTextFieldCell", for: indexPath) as! SingleTextFieldCell
            
            cell.textField.text = group?.title
            cell.textField.textColor = .white
            cell.textField.backgroundColor = group?.color
            cell.addDoneButtonOnKeyboard()
            cell.textField.delegate = self
            return cell
        default:
            fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case titleSection:
            return "Title"
        case colorSection:
            return "Color"
        default:
            fatalError("Unknown section")
        }
    }
}

extension EditGroupTVC: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        guard let enteredText = textField.text else { return true }
        
        if group != nil{
            group!.title = enteredText
        }else{
            group = Group(enteredText,UIColor.black)
        }
        delegate?.changedGroup(to: group!)
        return true
    }
}
