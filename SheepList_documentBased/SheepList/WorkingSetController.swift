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
    var missingSheeps = [String:Sheep]()
    var missingLambs = [String:Sheep]()
    var shouldMatchSheepsAndLambs = false
    
    override func deleteSheep(at index: Int){
        let sheep = displayedSheeps[index]
        modelC.document?.sheepList?.workingSet.removeValue(forKey: sheep.sheepID!)
        sheeps = modelC.document?.sheepList?.workingSet ?? [:]
        if shouldMatchSheepsAndLambs{
            missingLambs = [:]
            missingSheeps = [:]
            findMissingSheeps()
            sheeps.merge(missingSheeps) { (sheep, _) -> Sheep in
                return sheep
            }
        }
        recalculateDisplayedData()
        modelC.dataChanged()
    }
    
    override func viewDidLoad() {
        sheeps = modelC.document?.sheepList?.workingSet ?? [:]
        groups = modelC.document?.sheepList?.groups ?? []
        shouldDisplayLambsInsideSheepCell = false
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIBarButtonItem) {
        
        let chooseAction = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // Spesify where it will pop up when used on large screens
        chooseAction.popoverPresentationController?.barButtonItem = sender
        
        let matchSheepAndLambsAction = UIAlertAction(
            title: "Match Sheeps and Lambs",
            style: .default,
            handler: {action in
                self.matchSheepsAndLambs()
        })
        let unMatchSheepAndLambsAction = UIAlertAction(
            title: "Unmatch Sheeps and Lambs",
            style: .default,
            handler: { action in
                self.unMatchSheepsAndLambs()
        })
        if shouldMatchSheepsAndLambs {
            chooseAction.addAction(unMatchSheepAndLambsAction)
        }else{
            chooseAction.addAction(matchSheepAndLambsAction)
        }
        chooseAction.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        present(chooseAction, animated: true)
    }
    
    func findMissingSheeps() {
        for sheep in sheeps.values{
            if sheep.isLamb(), let mother = sheep.mother, !sheeps.values.contains(mother){
                missingSheeps[mother.sheepID!] = mother
                // Check for missing siblings
                for lamb in mother.lambs {
                    if lamb != sheep, !sheeps.values.contains(lamb){
                        missingLambs[lamb.sheepID!] = lamb
                    }
                }
            }else{
                for lamb in sheep.lambs{
                    if !sheeps.values.contains(lamb){
                        missingLambs[lamb.sheepID!] = lamb
                    }
                }
            }
        }
    }
    
    func matchSheepsAndLambs() {
        shouldMatchSheepsAndLambs = true
        shouldDisplayLambsInsideSheepCell = true
        setLabelEdgeColor = {sheep in
            if self.missingLambs.keys.contains(sheep.sheepID!) || self.missingSheeps.keys.contains(sheep.sheepID!){
                return .red
            }
            return nil
        }
        findMissingSheeps()
        sheeps.merge(missingSheeps) { (sheep, _) -> Sheep in
            return sheep
        }
        customSortText = "Missing"
        customSortCriterium = {(lhs:Sheep,rhs:Sheep)-> Bool in
            if self.missingSheeps.keys.contains(lhs.sheepID!){ return true }
            if self.missingSheeps.keys.contains(rhs.sheepID!){ return false}
            for lamb in lhs.lambs {
                if self.missingLambs.keys.contains(lamb.sheepID!) {return true}
            }
            return false
        }
        sortedBy = .custom
        reloadData()
    }
    
    func unMatchSheepsAndLambs(){
        shouldDisplayLambsInsideSheepCell = false
        shouldMatchSheepsAndLambs = false
        setLabelEdgeColor = nil
        customSortText = nil
        missingLambs = [:]
        missingSheeps = [:]
        sheeps = modelC.document?.sheepList?.workingSet ?? [:]
        sortedBy = .sheepID
        reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailedSheepViewController = segue.destination.childViewControllers.first
                as! EditSheepTableViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            detailedSheepViewController.modelC = modelC
            
            detailedSheepViewController.sheep = displayedSheeps[selectedRow].copy() as! Sheep
            detailedSheepViewController.sheepReference = displayedSheeps[selectedRow]
            
            
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
        if shouldMatchSheepsAndLambs{
            missingLambs = [:]
            missingSheeps = [:]
            findMissingSheeps()
            sheeps.merge(missingSheeps) { (sheep, _) -> Sheep in
                return sheep
            }
        }
        guard segue.identifier == "UnwindToWorkingSet" else { return }
        if let _ = tableView.indexPathForSelectedRow {
            //tableView.reloadRows(at: [selectedIndexPath], with: UITableViewRowAnimation.automatic )
        }
    }
}
