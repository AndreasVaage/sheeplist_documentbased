//
//  Sheep.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 30.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit

class Sheep: Equatable, Codable{

    enum CodingKeys: String, CodingKey
    {
        case sheepID
        case birthday
        case notes
        case assumedNumberOfLambs
        //case groupMemberships
        case _groupMemberships
        case female
        case weightings
        //case lambs
        //case mother
        //case biologicalMother
        //case father
        //case ram
        case _biologicalMotherID
        case _fatherID
        case _ramID
        case _motherID
        case _lambIDs
    }
    
    var sheepID: String?
    var birthday: Date?
    var notes: String?
    var lambs = [Sheep]()
    weak var mother: Sheep? = nil
    weak var biologicalMother: Sheep? = nil
    weak var father: Sheep? = nil
    weak var ram: Sheep? = nil
    var assumedNumberOfLambs = 0
    var groupMemberships = [Group]()
    var female = true
    var weightings = [Weigthing(weight: 40.5)]
    
    //var earlierYears = [Int:Sheep]()
    
    let lambPrefix = "70"
    
    // internal variables to store references in a JSON
    var _biologicalMotherID: String?
    var _fatherID: String?
    var _ramID: String?
    var _motherID: String?
    var _lambIDs = [String]()
    var _groupMemberships = [String]()
    
    
    init(sheepID: String?) {
        self.sheepID = sheepID
        self.lambs = []
        self.groupMemberships = []
    }
    convenience init(sheepID: String?, birthday: Date?) {
        self.init(sheepID: sheepID)
        self.birthday = birthday
    }
    convenience init(sheepID: String?, birthday: Date?, mother: Sheep?, father: Sheep?) {
        self.init(sheepID: sheepID, birthday: birthday)
        self.mother = mother
        self.father = father
    }
    
    func isLamb() -> Bool {
        return (self.sheepID?.hasPrefix(lambPrefix))!
    }
    
    func isCorrectFormat() -> Bool{
        guard sheepID != nil else { return false }
        guard sheepID != "" else { return false }
        for lamb in lambs {
            guard let lambID = lamb.sheepID else { return false }
            guard lambID != "" else { return false }
            guard lamb.lambs == [] else { return false }
        }
        if let mother = mother{
            guard let motherID = mother.sheepID else { return false }
            guard motherID != "" else { return false }
        }
        // MARK: - TODO check all entries

        return true
    }

    static let birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct Weigthing: Codable, Equatable{
     
    var weight = Float()
    var date: Date?
    
    init(weight: Float) {
        self.weight = weight
        date = Date()
    }
    
    static func ==(lhs: Weigthing, rhs: Weigthing) -> Bool {
        return lhs.date == rhs.date && lhs.weight == rhs.weight
    }
}

extension Sheep {
    static func ==(lhs: Sheep, rhs: Sheep) -> Bool {
        return (lhs.sheepID == rhs.sheepID &&
            lhs.birthday == rhs.birthday &&
            lhs.mother?.sheepID == rhs.mother?.sheepID &&
            lhs.father?.sheepID == rhs.father?.sheepID &&
            lhs.notes == rhs.notes &&
            lhs.lambs.elementsEqual(rhs.lambs, by: {$0 == $1}) &&
            lhs.biologicalMother?.sheepID == rhs.biologicalMother?.sheepID &&
            lhs.female == rhs.female &&
            lhs.assumedNumberOfLambs == rhs.assumedNumberOfLambs &&
            lhs.ram?.sheepID == rhs.ram?.sheepID &&
            lhs.groupMemberships == rhs.groupMemberships &&
            lhs.weightings == rhs.weightings
        ) }
}

extension Sheep: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Sheep(sheepID: sheepID, birthday: birthday, mother: mother, father: father)
        copy.notes = notes
        copy.lambs = lambs.map {$0.copy() as! Sheep}
        copy.biologicalMother = biologicalMother
        copy.female = female
        copy.assumedNumberOfLambs = assumedNumberOfLambs
        copy.ram = ram
        copy.groupMemberships = groupMemberships
        copy.weightings = weightings
        return copy
    }
    
    func setValues(equal sheep: Sheep){
        sheepID = sheep.sheepID
        birthday = sheep.birthday
        mother = sheep.mother
        father = sheep.father
        notes = sheep.notes
        lambs = sheep.lambs.map {$0.copy() as! Sheep}
        biologicalMother = sheep.biologicalMother
        female = sheep.female
        assumedNumberOfLambs = sheep.assumedNumberOfLambs
        ram = sheep.ram
        groupMemberships = sheep.groupMemberships
        weightings = sheep.weightings
    }
}

