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
    var missingSheeps = Set<Sheep>()
    var missingLambs = Set<Sheep>()
    var shouldMatchSheepsAndLambs = false
    
    override func deleteSheep(at index: Int){
        let sheep = displayedSheeps[index]
        modelC.document?.sheepList?.workingSet.remove(sheep)
        sheeps = modelC.document?.sheepList?.workingSet ?? []
        recalculateDisplayedData()
        modelC.dataChanged()
    }
    
    override func viewDidLoad() {
        sheeps = modelC.document?.sheepList?.workingSet ?? []
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
        for sheep in sheeps{
            if sheep.isLamb(), let mother = sheep.mother, !sheeps.contains(mother){
                missingSheeps.insert(mother)
            }else{
                for lamb in sheep.lambs{
                    if !sheeps.contains(lamb){
                        missingLambs.insert(lamb)
                    }
                }
            }
        }
    }
    
    
    func matchSheepsAndLambs() {
        shouldMatchSheepsAndLambs = true
        shouldDisplayLambsInsideSheepCell = true
        setLabelEdgeColor = {sheep in
            if self.missingLambs.contains(sheep) || self.missingSheeps.contains(sheep){
                return .red
            }
            return nil
        }
        findMissingSheeps()
        sheeps.formUnion(missingSheeps)
        reloadData()
        
    }
    
    func unMatchSheepsAndLambs(){
        shouldDisplayLambsInsideSheepCell = false
        shouldMatchSheepsAndLambs = false
        setLabelEdgeColor = nil
        missingLambs = []
        missingSheeps = []
        sheeps = modelC.document?.sheepList?.workingSet ?? []
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
        guard segue.identifier == "UnwindToWorkingSet" else { return }
        if let _ = tableView.indexPathForSelectedRow {
            //tableView.reloadRows(at: [selectedIndexPath], with: UITableViewRowAnimation.automatic )
        }
    }
}
