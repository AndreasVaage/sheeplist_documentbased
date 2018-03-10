//
//  RootTVC.swift
//  SheepList
//
//  Created by Andreas Våge on 30.07.2017.
//
//

import UIKit

class SheepTableVC: UITableViewController {
    
    // Used as a parentclass for displaying a list of sheeps. Only does the
    // visualization. Adding, deleting and editing must be done by the class
    // inheritating.
    enum Sortings {
        case groups
        case lambID
        case sheepID
        case custom
    }
    var sortedBy = Sortings.sheepID
    var isFiltering = false
    var sheeps = [String:Sheep]()
    var lambs = [String:Sheep]()
    var groups = [Group]()
    var filteredSheeps = [String:Sheep]()
    var shouldDisplayLambsInsideSheepCell = true
    var setLabelEdgeColor: ((Sheep) -> UIColor?)?
    var setLabelBackGroundColor: ((Sheep) -> UIColor?)?
    var customSortCriterium: ((Sheep,Sheep) -> Bool)?
    let searchController = UISearchController(searchResultsController: nil)
    var displayedSheeps = [Sheep]()
    
    func reloadData(){
        recalculateDisplayedData()
        tableView.reloadData()
    }
    
    func recalculateDisplayedData(){
        
        if isSearching == false{
            if shouldDisplayLambsInsideSheepCell{
                filteredSheeps = sheeps.filter({!$0.value.isLamb()})
            }else{
                filteredSheeps = sheeps
            }
        }
        switch sortedBy {
        case .groups:
            displayedSheeps = filteredSheeps.sorted(by:{
                guard let first = self.getHighestPriorityGroup(of: $0.value) else { return false}
                guard let second = self.getHighestPriorityGroup(of: $1.value) else { return true}
                return self.groups.first(where: {$0 == first || $0 == second}) == first
            }).map({$0.value})
        case .lambID:
            displayedSheeps = filteredSheeps.sorted(by:{
                guard let first = $0.value.lambs.first?.sheepID else { return false}
                guard let second = $1.value.lambs.first?.sheepID else {return true}
                return first < second
            }).map({$0.value})
        case .sheepID:
            displayedSheeps = filteredSheeps.sorted(by: {$0.value.sheepID! < $1.value.sheepID!}).map({$0.value})
        case .custom:
            displayedSheeps = filteredSheeps.sorted(by: {customSortCriterium!($0.value,$1.value)}).map({$0.value})
        }
    }
    
    func deleteSheep(at index: Int){
        fatalError("Must override deleteSheep function")
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        let chooseSortCrtiterium = UIAlertController(
            title: "Sort by:",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // Spesify where it will pop up when used on large screens
        chooseSortCrtiterium.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        
        chooseSortCrtiterium.addAction(UIAlertAction(
            title: "Groups",
            style: .default,
            handler: {action in
                self.sortedBy = .groups
                self.reloadData()
        }))
        chooseSortCrtiterium.addAction(UIAlertAction(
            title: "Lamb ID",
            style: .default,
            handler: { action in
                self.sortedBy = .lambID
                self.reloadData()
        }))
        chooseSortCrtiterium.addAction(UIAlertAction(
            title: "Sheep ID",
            style: .default,
            handler: { action in
                self.sortedBy = .sheepID
                self.reloadData()
        }))
        chooseSortCrtiterium.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        present(chooseSortCrtiterium, animated: true)
    }
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        let searchBar = searchController.searchBar
        searchBar.keyboardType = UIKeyboardType.numberPad
        tableView.tableHeaderView = searchBar
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    var isSearching: Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSheeps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SheepCellIdentifier") as? SheepCell else {
            fatalError("Could not dequeue a cell")
        }
        guard cell.LambStackView.subviews.count == cell.LambStackView.arrangedSubviews.count else {
            fatalError("Arranged subviews count dont match subview count")
        }
        let sheep: Sheep
        
        sheep = displayedSheeps[indexPath.row]
        
        cell.SheepIDLabel?.text = sheep.sheepID
        cell.SheepIDLabel.textColor = getHighestPriorityGroup(of: sheep)?.color
        addCustomDisplayFeature(to: cell.SheepIDLabel, for: sheep)
        for (index,lamb) in sheep.lambs.enumerated() {
            guard shouldDisplayLambsInsideSheepCell else {break}
            
            if cell.LambStackView.subviews.count > index{
                let label = cell.LambStackView.arrangedSubviews[index] as! PaddingLabel
                label.text = lamb.sheepID
                label.textColor = getHighestPriorityGroup(of: lamb)?.color
                addCustomDisplayFeature(to: label, for: lamb)
            }else{
                let label = PaddingLabel()
                label.text = lamb.sheepID
                label.textColor = getHighestPriorityGroup(of: lamb)?.color
                addCustomDisplayFeature(to: label, for: lamb)
                cell.LambStackView.addArrangedSubview(label)
            }
        }
        
        var desiredNumberOfSubviews = sheep.lambs.count
        if !shouldDisplayLambsInsideSheepCell{
            desiredNumberOfSubviews = 0
        }
        if cell.LambStackView.subviews.count > desiredNumberOfSubviews {
            for index in (desiredNumberOfSubviews...cell.LambStackView.subviews.count-1).reversed() {
                let view = cell.LambStackView.arrangedSubviews[index]
                view.removeFromSuperview()
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func addCustomDisplayFeature(to label: PaddingLabel, for sheep: Sheep){
        
        if let color = setLabelEdgeColor?(sheep)?.cgColor {
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 5.0
            label.layer.borderColor = color
        }else{
            label.layer.borderColor = nil
            label.layer.borderWidth = 0.0
            label.layer.cornerRadius = 0.0
        }
        
        if let color = setLabelBackGroundColor?(sheep){
            label.backgroundColor = color
        }else{
            label.backgroundColor = .white
        }
        //label.backgroundColor = setColorBasedOn?(sheep) ?? .white
    }
    
    func getHighestPriorityGroup(of sheep: Sheep) -> Group? {
        if sheep.groupMemberships == []{
            return nil
        }
        return groups.first(where: {sheep.groupMemberships.contains($0)})
    }
    
    // MARK: - Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSheep(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension SheepTableVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredSheeps = sheeps.filter { (key,sheep) in
            for lamb in sheep.lambs {
                if subSecuence(is: searchText.lowercased(), subSecuenceOff: lamb.sheepID!.lowercased()){
                    return true
                }
            }
            return subSecuence(is: searchText.lowercased(), subSecuenceOff: sheep.sheepID!.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func subSecuence(is str1: String,subSecuenceOff str2: String) -> Bool {
        if str1.isEmpty {
            return true
        }
        if str2.isEmpty{
            fatalError("Empty Sheep ID detected")
        }
        var offset = 0
        for letter in str2{
            guard let index =  str1.index(str1.startIndex, offsetBy: offset, limitedBy: str1.index(before: str1.endIndex)) else{
                return true
            }
            if letter == str1[index]{
                offset += 1
            }
        }
        return offset == str1.count
    }
}
