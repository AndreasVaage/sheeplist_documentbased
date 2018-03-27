//
//  ChooseGroupTVC.swift
//  SheepList
//
//  Created by Andreas Våge on 03.12.2017.
//

import UIKit

protocol ChooseGroupsTVCDelegate {
    func didSelect(_ groupMemberships: [Group])
    func changedGroups(to newGroups: [Group])
    func changedGroups(to newGroups: [Group], deleted deletedGroup: Group)
}

class ChooseGroupTVC: UITableViewController {
    var delegate: ChooseGroupsTVCDelegate?
    var groupMemberships: [Group]?
    var groups = [Group]()
    
    var creatingNewGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath) as? ChooseGroupCell else{
            fatalError("Can't deque chooseGroupCell")
        }
        guard let groupMemberships = groupMemberships else {
            print("No GroupMemberships")
            return cell
        }
        // Configure the cell...
        let group = groups[indexPath.row]
        guard let textLabel = cell.textLabel else {
            print("No TextLabel")
            return cell
        }
        if groupMemberships.contains(groups[indexPath.row]) {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        textLabel.text = group.title
        textLabel.textColor = group.color
        
        //        if groupMemberships[indexPath.row] {
        //            textLabel.alpha = 1.0
        //            textLabel.isEnabled = true
        //        }else{
        //            textLabel.alpha = 0.1
        //            textLabel.isEnabled = false
        //        }
        return cell
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: "editGroup", sender: nil)
        }else{
            groupMemberships!.append(groups[indexPath.row])
            delegate?.didSelect(groupMemberships!)
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard !isEditing else {return}
        
        groupMemberships!.remove(at: (groupMemberships?.index(of: groups[indexPath.row])!)!)
        delegate?.didSelect(groupMemberships!)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == false {
            tableView.reloadData()
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedGroup = groups.remove(at: indexPath.row)
            delegate?.changedGroups(to: groups, deleted: deletedGroup)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("You just inserted a group")
            
        }    
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        groups.insert(groups.remove(at: fromIndexPath.row), at: to.row)
        delegate?.changedGroups(to: groups)
    }
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let editGroupTVC = segue.destination as! EditGroupTVC
        switch segue.identifier ?? "" {
        case "editGroup":
            let indexPath = tableView.indexPathForSelectedRow!
            editGroupTVC.group = groups[indexPath.row]
            break
        case "newGroup":
            editGroupTVC.group = nil
            creatingNewGroup = true
            break
        default:
            fatalError("UNknown segue identifieer: \(segue.identifier ?? "")")
        }
        editGroupTVC.delegate = self
    }
    
}

extension ChooseGroupTVC: EditGroupTVCDelegate {

    func changedGroup(to newGroup: Group){
        if creatingNewGroup == true {
            let indexPath = IndexPath.init(row: groups.count-1, section: 0)
            groups.append(newGroup)
            delegate?.changedGroups(to: groups)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            creatingNewGroup = false
        }else{
            let indexPath = tableView.indexPathForSelectedRow!
            groups[indexPath.row] = newGroup
            print(groups.map{$0.title})
            delegate?.changedGroups(to: groups)
        }
    }
}
