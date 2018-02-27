//
//  WorkingSetTVC.swift
//  SheepList
//
//  Created by Andreas Våge on 30.07.2017.
//
//


import UIKit

class WorkingSetController: SheepTableVC {
    var modelC: ModelController!
    var missingSheeps = [Sheep]()
    var missingLambs = [Sheep]()
    var lambs = [Sheep]()
    
    override func deleteSheep(at index: Int){
        modelC.document?.sheepList?.workingSet.remove(at: index)
        sheeps = modelC.document?.sheepList?.workingSet ?? []
        modelC.dataChanged()
    }
    
    override func viewDidLoad() {
        sheeps = modelC.document?.sheepList?.workingSet ?? []
        groups = modelC.document?.sheepList?.groups ?? []
        shouldDisplayLambs = false

        
        super.viewDidLoad()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIBarButtonItem) {
        
        let chooseAction = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // Spesify where it will pop up when used on large screens
        chooseAction.popoverPresentationController?.barButtonItem = sender
        
        chooseAction.addAction(UIAlertAction(
            title: "Match Sheeps and Lambs",
            style: .default,
            handler: {action in
                self.matchSheepsAndLambs()
        }))
        chooseAction.addAction(UIAlertAction(
            title: "Unmatch Sheeps and Lambs",
            style: .default,
            handler: { action in
                self.unMatchSheepsAndLambs()
        }))
        chooseAction.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        present(chooseAction, animated: true)
    }
    
    func matchSheepsAndLambs() {
        for sheep in sheeps{
            if !sheep.isLamb(){
                for lamb in sheep.lambs{
                    if sheeps.contains(lamb), !lambs.contains(lamb){
                        lambs.append(lamb)
                    }else if !missingLambs.contains(lamb){
                        missingLambs.append(lamb)
                    }
                }
            }else{
                if let mother = sheep.mother,
                    !sheeps.contains(mother),
                    !missingSheeps.contains(mother){
                    missingSheeps.append(mother)
                    if !lambs.contains(sheep){
                        lambs.append(sheep)
                    }
                }
            }
        }
        sheeps = sheeps.filter{!lambs.contains($0) && !missingLambs.contains($0)}
        sheeps.append(contentsOf: missingSheeps)
        
        shouldDisplayLambs = true
        setLabelEdgeColor = {sheep in
            if self.missingLambs.contains(sheep) || self.missingSheeps.contains(sheep){
                return .red
            }
            return nil
        }
        tableView.reloadData()
    }
    
    func unMatchSheepsAndLambs(){
        lambs = []
        missingLambs = []
        missingSheeps = []
        sheeps = modelC.document?.sheepList?.workingSet ?? []
        shouldDisplayLambs = false
        setLabelEdgeColor = nil
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailedSheepViewController = segue.destination.childViewControllers.first
                as! EditSheepTableViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedSheepViewController.modelC = modelC
            if searchController.isActive && searchController.searchBar.text != "" {
                detailedSheepViewController.sheep = filteredSheeps[selectedRow].copy() as! Sheep
                detailedSheepViewController.sheepReference = filteredSheeps[selectedRow]
            }else{
                detailedSheepViewController.sheep = sheeps[selectedRow].copy() as! Sheep
                detailedSheepViewController.sheepReference = sheeps[selectedRow]
            }
            
            detailedSheepViewController.seguedFrom = "workingSet"
        }else if segue.identifier == "addSheep"{
            
            let addSheeptableNC = segue.destination as! UINavigationController
            let addSheeptableVC = addSheeptableNC.topViewController as! AddSheepsToWorkingSetTVC
            addSheeptableVC.modelC = modelC
        }else{
            fatalError("Unknown Segue")
        }
    }
    
    @IBAction func unwindToWorkingSet(segue: UIStoryboardSegue) {
        sheeps = modelC.workingSet
        guard segue.identifier == "UnwindToWorkingSet" else { return }
        if let _ = tableView.indexPathForSelectedRow {
            //tableView.reloadRows(at: [selectedIndexPath], with: UITableViewRowAnimation.automatic )
        } 
    }
}
