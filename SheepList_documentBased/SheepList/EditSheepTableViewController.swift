//
//  EditSheepTableViewController.swift
//  SheepList
//
//  Created by Andreas Våge on 24.06.2017.
//
//

import UIKit


class EditSheepTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    var modelC: ModelController?
    var sheep = Sheep(sheepID: nil)
    var lambIndex: Int?
    var sheepIndex: Int?
    var seguedFrom: String?
    var isDatePickerHidden = true
    var isEnteringID = false
    
    let sheepSection = 0
    let birtdaySection = 1
    let notesSection = 2
    let groupSection = 3
    let genderSection = 4
    let weightSection = 5
    let familySection = 6
    let lambSection = 7
    
    var numberOfLambIdGuesses = [Int]()
    let numberOfAllowedGuesses = 1
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addLambButton: UIButton!
    
    func updateModel() {
        // Gets called every time user changes something
        
        //modelC.save(sheep: sheep, sheepIndex: sheepIndex, lambIndex: lambIndex)
        // Not needed as Sheep is a reference type
        
        modelC?.dataChanged()
    }
    
    @IBAction func addLambButtonPressed(_ sender: UIButton) {
        let newIndexPath = IndexPath(row: sheep.lambs.count ,section: lambSection)
        
        sheep.lambs.append(Sheep(sheepID: suggestLambID(lastSugestion: nil), birthday: Date(), motherID: sheep.sheepID, fatherID: sheep.ramID))
        sheep.lambs.last?.biologicalMotherID = sheep.sheepID
        numberOfLambIdGuesses.append(0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        updateLambHeader()
        updateLambFooter()
        tableView.scrollToBottom(ofSection: lambSection)
    }
    
    func suggestLambID(lastSugestion: String?) -> String? {
        var sheepID: String? = nil
        if lastSugestion == nil {
            if let lastEnteredLambID = sheep.lambs.last?.sheepID {
                sheepID = String(describing: Int(lastEnteredLambID)! + 1)
            }else if let lastSavedLambID = modelC?.findLastSavedLambID() {
                sheepID = String(describing: Int(lastSavedLambID)! + 1)
            }
        }else{
            sheepID = String(describing: (Int(lastSugestion!)! / 10000)) + "0000"
        }
        
        if sheepID == nil {
            sheepID = sheep.lambPrefix + "000"
        }
        
        while (modelC?.document?.sheepList?.allSheepAndLambIDs ?? []).contains(sheepID!) {
            sheepID = String(describing: Int(sheepID!)!+1)
        }
        return sheepID
    }
    
    @IBAction func birthdayPickerChanged(_ sender: UIDatePicker) {
        updateBirthdayLabel(date: sender.date)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        updateSaveButtonState()
        updateLambFooter()
        
        numberOfLambIdGuesses = Array(repeating: 1, count: sheep.lambs.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case birtdaySection:
            isDatePickerHidden = !isDatePickerHidden
            let cell = tableView.cellForRow(at: indexPath) as! DateTVCell
            let color = isDatePickerHidden ? .black : tableView.tintColor
            cell.dateLabel.textColor = color
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    //MARK: - Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == lambSection {
            return true
        }else {
            return false
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.sheep.lambs.remove(at: indexPath.row)
            self.numberOfLambIdGuesses.remove(at: indexPath.row)
            self.updateModel()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateLambHeader()
            self.updateLambFooter()
        }
        deleteAction.backgroundColor = .red
        
        let groupsSortedByPopularity = modelC?.document?.sheepList?.groups.sorted(by: {$0.popularity > $1.popularity} )
        
        guard let group1 = groupsSortedByPopularity?.first else {return [deleteAction]}
        
        let editAction = UITableViewRowAction(style: .normal, title: group1.title) { (rowAction, indexPath) in
            
            if let index1 = self.sheep.lambs[indexPath.row].groupMemberships.index(of: group1) {
                self.sheep.lambs[indexPath.row].groupMemberships.remove(at: index1)
            }else {
                self.sheep.lambs[indexPath.row].groupMemberships.append(group1)
            }
            self.updateModel()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            //let cell = self.tableView.cellForRow(at: indexPath) as! LambCell
            //cell.lambIDTextField.textColor = group1.color
            group1.popularity += 1
            self.tableView.endEditing(true)
            self.tableView.setEditing(false, animated: true)
        }
        editAction.backgroundColor = group1.color
        
        let moreAcction = UITableViewRowAction(style: .default, title: "More") { (rowAction, indexPath) in
            let choseGroupAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                choseGroupAction.addAction(UIAlertAction(title: "Print Year", style: .default, handler: {action in
                //self.performSegue(withIdentifier: "chooseGroup", sender: self.sheep.lambs[indexPath.row])
                    print("Born in: \(self.sheep.birthday?.getYear() ?? -1)")
                self.tableView.endEditing(true)
                self.tableView.setEditing(false, animated: true)
            }))
            self.present(choseGroupAction, animated: true)
        }
        moreAcction.backgroundColor = .gray
        
        return [deleteAction,editAction,moreAcction]
    }
    
    func updateSaveButtonState() {
        if Sheep.isCorrectFormat(for: sheep) && isEnteringID == false{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    
}


// MARK: - Display

extension EditSheepTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case lambSection:
            return sheep.lambs.count
        case familySection:
            return 4
        case weightSection:
            return sheep.weightings.count
        default:
            return 1
        }
    }
    
    // Display rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.cellLayoutMarginsFollowReadableWidth = true
        switch indexPath.section{
        case sheepSection: // sheepID
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditSheepCell") as? EditSheepTableViewCell else {
                fatalError("Could not dequeue a cell")
            }
            cell.sheepIDTextField.text = sheep.sheepID
            cell.sheepIDTextField.textColor = modelC?.document?.sheepList?.getMostImportentGroupColor(for: sheep)
            cell.addDoneButtonOnKeyboard()
            cell.sheepIDTextField.delegate = self
            return cell
        case birtdaySection: //datepicker
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as? DateTVCell else {
                fatalError("Could not dequeue a cell")
            }
            if let sheepBirthday = sheep.birthday {
                cell.datePicker.date = sheepBirthday
                cell.dateLabel.text = Sheep.birthdayFormatter.string(from: sheepBirthday)
            }else{
                cell.dateLabel.text = "Unknown"
            }
            return cell
        case notesSection: // notes
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell") as? TextViewCell else {
                fatalError("Could not dequeue a cell")
            }
            cell.notesTextView.text = sheep.notes
            cell.notesTextView.delegate = self
            return cell
        case groupSection: //groups
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayGroupsCell") as? DisplayGroupsCell else {
                fatalError("Could not dequeue a cell")
            }
            return cell
        case lambSection: // lambs
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LambCell") as? LambCell else {
                fatalError("Could not dequeue a cell")
            }
            cell.lambIDTextField.text = sheep.lambs[indexPath.row].sheepID
            cell.lambIDTextField.delegate = self
            cell.lambIDTextField.textColor = modelC?.document?.sheepList?.getMostImportentGroupColor(for: sheep.lambs[indexPath.row])
            if let sheepBirthday = sheep.lambs[indexPath.row].birthday {
                cell.DateLabel.text = Sheep.birthdayFormatter.string(from: sheepBirthday)
            }else{
                cell.DateLabel.text = "Unknown"
            }
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.addDoneButtonOnKeyboard()
            return cell
            
        case genderSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditSheepCell") as? EditSheepTableViewCell else {
                fatalError("Could not dequeue a cell")
            }
            var gender = "M"
            if sheep.female { gender = "F"}
            cell.sheepIDTextField.text = gender
            cell.sheepIDTextField.delegate = self
            return cell
            
        case weightSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextFieldCell") as? LabelAndTextFieldCell else {
                fatalError("Could not dequeue a cell")
            }
            cell.label.text = sheep.weightings[indexPath.row].date?.getDayAndMont()
            cell.textField.text = String(describing: sheep.weightings[indexPath.row].weight)
            cell.textField.delegate = self
            cell.addDoneButtonOnKeyboard()
            cell.textField.keyboardType = .decimalPad
            return cell
            
        case familySection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextFieldCell") as? LabelAndTextFieldCell else {
                fatalError("Could not dequeue a cell")
            }
            switch indexPath.row {
            case 0:
                cell.label.text = "Mother ID"
                cell.textField.text = sheep.motherID
            case 1:
                cell.label.text = "Biological Mother ID"
                cell.textField.text = sheep.biologicalMotherID
            case 2:
                cell.label.text = "Father ID"
                cell.textField.text = sheep.fatherID
            case 3:
                cell.label.text = "Ram ID"
                cell.textField.text = sheep.ramID
            default:
                fatalError("Not correct amount of family members")
            }
            cell.addDoneButtonOnKeyboard()
            cell.textField.delegate = self
            cell.textField.keyboardType = .numberPad
            cell.textField.placeholder = "Sheep ID"
            return cell
        default:
            fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? DisplayGroupsCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    //give each section a title
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case birtdaySection:
            return "Birthday"
        case notesSection:
            return "Notes"
        case groupSection:
            return "Groups"
        case lambSection:
            if sheep.lambs.count == 1 {
                return " 1 lamb"
            }else{
                return  String(sheep.lambs.count) + " lambs"
            }
        case weightSection:
            return "Weightings"
        case genderSection:
            return "Gender"
        case familySection:
            return "Family"
        default:
            return nil
        }
    }
    
    func updateLambFooter() {
        if sheep.lambs.count >= 9 {
            addLambButton.titleLabel?.text = "max number of lambs"
            addLambButton.isEnabled = false
        }else{
            addLambButton.titleLabel?.text = "Register new lamb"
            addLambButton.isEnabled = true
        }
    }
    
    func updateLambHeader(){
        
        let header = tableView.headerView(forSection: lambSection)
        let numberOfLambs = sheep.lambs.count
        var headerText = String(numberOfLambs) + " lamb"
        if numberOfLambs != 1 {
            headerText += "s"
        }
        if numberOfLambs == 9 {
            headerText += " (max)"
        }
        header?.textLabel?.text = headerText
        header?.textLabel?.sizeToFit()
    }
    
    func updateBirthdayLabel(date: Date?) {
        guard let cell = tableView.cellForRow(at: IndexPath(item: 0, section: birtdaySection)) as? DateTVCell else{fatalError("Wrong cell")}
        if let date = date{
            cell.dateLabel.text = Sheep.birthdayFormatter.string(from: date)
            sheep.birthday = date
            updateModel()
        }else{
            cell.dateLabel.text = "Unknown"
        }
    }
    
    //set row higth for each cell
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let headerCellHeight = CGFloat(60)
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch indexPath.section {
        case sheepSection:
            return headerCellHeight
        case birtdaySection:
            return isDatePickerHidden ? normalCellHeight : largeCellHeight
        case notesSection:
            tableView.estimatedRowHeight = normalCellHeight
            return UITableViewAutomaticDimension
        case groupSection:
            return normalCellHeight
        case lambSection:
            return normalCellHeight
        case genderSection:
            return normalCellHeight
        case familySection:
            return normalCellHeight
        case weightSection:
            return normalCellHeight
        default:
            fatalError("Unknown section")
        }
    }
}

// MARK: - Navigation

extension EditSheepTableViewController {
    
    @IBAction func unwindToEditSheep(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveUnwind(_ sender: UIBarButtonItem) {
        switch seguedFrom! {
        case "workingSet":
            self.performSegue(withIdentifier: "UnwindToWorkingSet", sender: nil)
        case "sheepList":
            self.performSegue(withIdentifier: "SaveUnwindToSheepList", sender: nil)
        case "editTheMotherTVC":
            self.performSegue(withIdentifier: "unwindToEditSheep", sender: nil)
        default:
            fatalError("Unknown segueFrom value")
        }
    }
    
    @IBAction func cancelUnwind(_ sender: UIBarButtonItem) {
        switch seguedFrom! {
        case "workingSet":
            self.performSegue(withIdentifier: "UnwindToWorkingSet", sender: nil)
        case "sheepList":
            self.performSegue(withIdentifier: "cancelUnwindToSheepList", sender: nil)
        case "editTheMotherTVC":
            self.performSegue(withIdentifier: "unwindToEditSheep", sender: nil)
        default:
            fatalError("Unknown segueFrom value")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "chooseGroup":
            let chooseGroupTVC = segue.destination as! ChooseGroupTVC
            //if let lamb = sender as? Sheep {
            //    chooseGroupTVC.groupMemberships = lamb.groupMemberships
            //}else{
            chooseGroupTVC.groupMemberships = sheep.groupMemberships
            //}
            chooseGroupTVC.groups = modelC?.document?.sheepList?.groups ?? []
            chooseGroupTVC.delegate = self
            return
        case "editLamb":
            let editSheepTVC = segue.destination as! EditSheepTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            editSheepTVC.modelC = modelC
            editSheepTVC.sheep = sheep.lambs[indexPath.row]
            editSheepTVC.lambIndex = indexPath.row
            editSheepTVC.sheepIndex = sheepIndex
            editSheepTVC.seguedFrom = "editTheMotherTVC"
            return
        case "SaveUnwindToDetailedSheep":
            guard Sheep.isCorrectFormat(for: sheep) else {
                fatalError("Trying to save sheep with wrong format")
            }
            return
        case "SaveUnwindToSheepList":
            guard Sheep.isCorrectFormat(for: sheep) else {
                fatalError("Trying to save sheep with wrong format")
            }
            return
        default:
            return
        }
    }
}
// MARK: - Alerts
extension EditSheepTableViewController {
    func presentNotUniqueSheepIDAllert(){
        let alert = UIAlertController(
            title: "Sheep ID already exists",
            message: "Do you want to edit the existing sheep insted?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Change this ID",
            style: .default
        ))
        alert.addAction(UIAlertAction(
            title: "Edit existing sheep* ",
            style: .destructive,
            handler: { action in
                print("\nYOU DID SOMEtHING! :O \n")
        }))
        present(alert, animated: true)
    }
}

// MARK: - NotesTextView
extension EditSheepTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sheep.notes = textView.text
        updateModel()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension EditSheepTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let cell = textField.superview?.superview as? UITableViewCell else{
            fatalError("Unknown cell")
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            fatalError("Unknown indexpath")
        }
        
        if indexPath.section == genderSection {
            if sheep.female{
                textField.text = "M"
                sheep.female = false
            }else{
                textField.text = "F"
                sheep.female = true
            }
            return false
        }
        
        if indexPath.section == lambSection && numberOfLambIdGuesses[indexPath.row] < numberOfAllowedGuesses{
            let suggestedID = suggestLambID(lastSugestion: textField.text)
            textField.text = suggestedID
            sheep.lambs[indexPath.row].sheepID = suggestedID
            numberOfLambIdGuesses[indexPath.row] += 1;
            return false
        }else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEnteringID = true
        updateSaveButtonState()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let cell = textField.superview?.superview as? UITableViewCell else{
            fatalError("Unknown cell")
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            fatalError("Unknown indexpath")
        }
        let enteredText = textField.text
        
        guard modelC!.sheepIdIsUnique(enteredText) || enteredText == sheep.sheepID || enteredText == sheep.lambs[indexPath.row].sheepID else {
            presentNotUniqueSheepIDAllert()
            //textField.text = nil
            return false
        }
        
        switch indexPath.section {
        case sheepSection:
            if sheep.sheepID == nil {
                sheep.sheepID = enteredText
                if !modelC!.save(sheep: sheep, sheepIndex: sheepIndex, lambIndex: lambIndex){
                    fatalError("SaveFailed")
                }
            }
            sheep.sheepID = enteredText
        case lambSection:
            sheep.lambs[indexPath.row].sheepID = enteredText
        case familySection:
            switch indexPath.row {
            case 0:
                sheep.motherID = enteredText
            case 1:
                sheep.biologicalMotherID = enteredText
            case 2:
                sheep.fatherID = enteredText
            case 3:
                sheep.ramID = enteredText
            default:
                fatalError("Not correct amount of family members")
            }
        case weightSection:
            sheep.weightings[indexPath.row].weight = (enteredText?.floatValue)!
        default:
            fatalError("Section should not have a textfield")
        }
        isEnteringID = false
        updateSaveButtonState()
        updateModel()
        return true
    }    
}

// MARK: - Sheep Groups

extension EditSheepTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheepGroupCell",
                                                      for: indexPath as IndexPath) as! SheepGroupCell
        
        let group = sheep.groupMemberships[indexPath.row]
        cell.groupLabel.text = group.title
        cell.groupLabel.backgroundColor = group.color
        cell.groupLabel.textColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return sheep.groupMemberships.count
    }
    
}

extension EditSheepTableViewController: ChooseGroupsTVCDelegate {
    func didSelect(_ groupMemberships: [Group]){
        //guard let indexpath = self.tableView.indexPathForSelectedRow else { fatalError("Not able to determine where to save group")}
        //if indexpath.section == lambSection{
        //    self.sheep.lambs[indexpath.row].groupMemberships = groupMemberships
        //}else{
            self.sheep.groupMemberships = groupMemberships
        //}
        updateModel()
        tableView.reloadData()
    }
    
    func changedGroups(to newGroups: [Group]) {
        modelC!.document?.sheepList?.groups = newGroups
        updateModel()
        tableView.reloadData()
    }
    
    func changedGroups(to newGroups: [Group], deleted deletedGroup: Group){
        for sheep in modelC!.everyOneByThemSelf {
            if let indexPath = sheep.groupMemberships.index(of: deletedGroup){
                sheep.groupMemberships.remove(at: indexPath)
            }
        }
        modelC?.document?.sheepList?.groups = newGroups
        updateModel()
        tableView.reloadData()
    }
}

extension UITableView {
    
    func scrollToBottom(ofSection section: Int) {
        let rows = self.numberOfRows(inSection: section)
        
        let indexPath = IndexPath(row: rows - 1, section: section)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    
    func getYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        let strYear = dateFormatter.string(from: self)
        return Int(strYear)!
    }
    func getDayAndMont() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. LLL"
        return formatter.string(from: self)
    }
}

extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}
