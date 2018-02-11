//
//  SettingsTVC.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 11.02.2018.
//  Copyright © 2018 Andreas Våge. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    var documentBrowserVC: DocumentBrowserViewController?
    var setting: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        switch indexPath.row {
        case 2:
            cell.textLabel?.text = "Change Document"
        case 1:
            cell.textLabel?.text = "Bluetooth"
        case 0:
            cell.textLabel?.text = "Groups"
        default:
            fatalError("Uniplemented Setting")
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            documentBrowserVC?.dismiss(animated: true, completion: nil)
        case 1:
            setting = "Bluetooth"
            performSegue(withIdentifier: "DetailedSetting", sender: nil)
        case 0:
            setting = "Groups"
            performSegue(withIdentifier: "DetailedSetting", sender: nil)
        default:
            return
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "DetailedSetting":
            let destination = segue.destination as! UINavigationController
            destination.performSegue(withIdentifier: "editGroups", sender: nil)
        default:
            return
        }
    }

}
