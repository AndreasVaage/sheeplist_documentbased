//
//  SheepListTableViewController.swift
//  SheepList
//
//  Created by Andreas Våge on 21.06.2017.
//
//

import UIKit

class SheepListController: SheepTableVC {
    var modelC: ModelController!
    
    override func deleteSheep(at index: Int){
        modelC.delete(sheep: sheeps[index])
        sheeps = modelC.sheeps
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func updateViewFromModel() {
        sheeps = modelC.document?.sheepList?.sheeps ?? []
        groups = modelC.document?.sheepList?.groups ?? []
        tableView.reloadData()
    }
}

// MARK: - Navigation

extension SheepListController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails", let editSheepTVC = segue.destination.childViewControllers.first
            as? EditSheepTableViewController {
            editSheepTVC.modelC = modelC
            if searchController.isActive && searchController.searchBar.text != "" {
                editSheepTVC.sheep = filteredSheeps[tableView.indexPathForSelectedRow!.row].copy() as! Sheep
                editSheepTVC.sheepReference = filteredSheeps[tableView.indexPathForSelectedRow!.row]
            }else{
                editSheepTVC.sheep = sheeps[tableView.indexPathForSelectedRow!.row].copy() as! Sheep
                editSheepTVC.sheepReference = sheeps[tableView.indexPathForSelectedRow!.row]
            }
           // modelC.selectedSheep = indexPath.row
            
            editSheepTVC.seguedFrom = "sheepList"
        }else if segue.identifier == "newSheep", let addSheeptableVC = (segue.destination as? UINavigationController)?.topViewController as? EditSheepTableViewController {
            
            addSheeptableVC.modelC = modelC
            addSheeptableVC.seguedFrom = "sheepList"
            addSheeptableVC.sheepIndex = nil
        }else{
            fatalError("Unknown Segue")
        }
    }
        
    @IBAction func unwindToSheepList(segue: UIStoryboardSegue) {
        //guard segue.identifier == "SaveUnwindToSheepList" else { return }
        updateViewFromModel()
        
        //return
        
//
//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            sheeps = modelC.document!.sheepList!.sheeps!
//            tableView.reloadRows(at: [selectedIndexPath], with: UITableViewRowAnimation.automatic )
//        } else {
//            if let sheepList = modelC.document?.sheepList{
//                sheeps = sheepList.sheeps!
//            }else {
//                print("\nNo sheepList !")
//            }
//            let newIndexPath = IndexPath(row: modelC.sheeps.count-1, section: 0)
//            tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.bottom )
//        }
    }
}
