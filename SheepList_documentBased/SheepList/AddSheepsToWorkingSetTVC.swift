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
        shouldDisplayLambsInsideSheepCell = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheep = displayedSheeps[indexPath.row]
        modelC.document?.sheepList?.workingSet[sheep.sheepID!] = sheep
        modelC.dataChanged()
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedSheep = displayedSheeps[indexPath.row]
        modelC.document?.sheepList?.workingSet.removeValue(forKey: deselectedSheep.sheepID!)
        modelC.dataChanged()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSheepCell") as? SingleSheepCell else {
            fatalError("Could not dequeue a cell")
        }
        let sheep = displayedSheeps[indexPath.row]
        
        cell.textLabel?.text = sheep.sheepID
        //cell.textLabel?.textColor = sheep.activeGroupMemberships().first?.color
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelected(modelC.workingSet.keys.contains(displayedSheeps[indexPath.row].sheepID!), animated: false)
    }
    
}
