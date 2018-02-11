//
//  File.swift
//  SheepList
//
//  Created by Andreas Våge on 30.07.2017.
//
//

import UIKit

class AddSheepsToWorkingSetTVC: SheepTableVC {
    var modelC: ModelController!

    override func viewDidLoad() {
        sheeps = modelC.sheeps
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modelC.document?.sheepList?.workingSet.append(sheeps[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        modelC.document?.sheepList?.workingSet.remove(at: modelC.workingSet.index(of: sheeps[indexPath.row])!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSheepCell") as? SingleSheepCell else {
            fatalError("Could not dequeue a cell")
        }
        let sheep: Sheep
        if searchController.isActive && searchController.searchBar.text != "" {
            sheep = filteredSheeps[indexPath.row]
        }else{
            sheep = sheeps[indexPath.row]
        }
        cell.textLabel?.text = sheep.sheepID
        //cell.textLabel?.textColor = sheep.activeGroupMemberships().first?.color
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelected(modelC.workingSet.contains(sheeps[indexPath.row]), animated: false)
    }

}
