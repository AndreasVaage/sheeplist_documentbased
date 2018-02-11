//
//  DetailedSheepViewController.swift
//  SheepList
//
//  Created by Andreas Våge on 22.06.2017.
//
//

import UIKit

class DetailedSheepViewController: UITableViewController {
    var sheep: Sheep?
    var sheepIndex: Int?
    var modelC: ModelController!
    let sheepSection = 0
    let lambSection = 1
    
    private func presentTestAllert(){
        let alert = UIAlertController(
            title: "Test Allert",
            message: "This is a test",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))
        alert.addAction(UIAlertAction(
            title: "Do something",
            style: .destructive,
            handler: { action in
                print("\nYOU DID SOMEtHING! :O \n")
        }))
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() { // runs only one time: when the viewcontroller is created.
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // return how many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sheepSection {
            return 1
        }else{
            if let numberOfRows = sheep?.lambs.count{
            return numberOfRows
            } else {
                print("Could not load a sheep")
                return 0
            }
        }
    }
    //what are the content of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedSheepCell") as? DetailedSheepCell else {
            fatalError("Could not dequeue a cell")
        }
        
        if indexPath.section == sheepSection {
            if let sheep = sheep{
                cell.sheepIDTextLabel.text = sheep.sheepID
                cell.sheepIDTextLabel.textColor = modelC.document?.sheepList?.getMostImportentGroupColor(for: sheep)
                updateBirthdayLabel(date: sheep.birthday, cell: cell)
                cell.notesTextField.text = sheep.notes
            }
            else{
                print("No sheep")
            }
            
        }else{
            if let lambs = sheep?.lambs{
                cell.sheepIDTextLabel.text = lambs[indexPath.row].sheepID
                cell.sheepIDTextLabel.textColor = modelC.document?.sheepList?.getMostImportentGroupColor(for: lambs[indexPath.row])
                updateBirthdayLabel(date: lambs[indexPath.row].birthday, cell: cell)
                cell.notesTextField.text = lambs[indexPath.row].notes
            }else{
                fatalError("No sheep/lambs")
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func updateBirthdayLabel(date: Date?, cell: DetailedSheepCell) {
        if let date = date {
            cell.birthdayLabel.text = Sheep.birthdayFormatter.string(from: date)
        }else{
            cell.birthdayLabel.text = "Unknown"
        }
        
    }
    //give each section a title
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sheep"
        }else{
            return "Lambs"
        }
    }
    func updateData() {
        sheep = modelC.sheeps[sheepIndex!]
        tableView.reloadData()
    }
}

// MARK: - Navigation

extension DetailedSheepViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editSheep" else { return }
        
        let addSheeptableNC = segue.destination as! UINavigationController
        let editSheeptableVC = addSheeptableNC.topViewController as! EditSheepTableViewController
        
        editSheeptableVC.sheepIndex = sheepIndex
        
        if let indexPath = tableView.indexPathForSelectedRow, indexPath.section == lambSection{
            editSheeptableVC.sheep = (sheep?.lambs[indexPath.row])!
            editSheeptableVC.lambIndex = indexPath.row
            editSheeptableVC.seguedFrom = "detailedSheep"
        }else{
            editSheeptableVC.sheep = sheep!
            editSheeptableVC.lambIndex = nil
            editSheeptableVC.seguedFrom = "sheepList"
        }
        
        editSheeptableVC.modelC = modelC
    }
    
    @IBAction func unwindToDetailedSheep(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwindToDetailedSheep" else { return }
        
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        guard selectedIndexPath.section == lambSection else {
            fatalError("Not possible to unwind to this view without editing lamb info")
        }
        updateData()
    }
}


