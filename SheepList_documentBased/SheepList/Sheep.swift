//
//  Sheep.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 30.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit

class Sheep: Equatable, Codable, NSCopying {
    
    var sheepID: String?
    var birthday: Date?
    var notes: String?
    var lambs: [Sheep]
    var motherID: String?
    var biologicalMotherID: String?
    var fatherID: String?
    var ramID: String?
    var assumedNumberOfLambs = 0
    var groupMemberships: [Group]
    var female = true
    var weightings = [Weigthing(weight: 40.5)]
    
    var earlierYears = [Int:Sheep]()
    
    let lambPrefix = "70"
    
    init(sheepID: String?) {
        self.sheepID = sheepID
        self.lambs = []
        self.groupMemberships = []
    }
    convenience init(sheepID: String?, birthday: Date?) {
        self.init(sheepID: sheepID)
        self.birthday = birthday
    }
    convenience init(sheepID: String?, birthday: Date?, motherID: String?, fatherID: String?) {
        self.init(sheepID: sheepID, birthday: birthday)
        self.motherID = motherID
        self.fatherID = fatherID
    }
    
    func isLamb() -> Bool {
        return (self.sheepID?.hasPrefix(lambPrefix))!
    }
    
    static func isCorrectFormat(for sheep: Sheep) -> Bool{
        guard let sheepID = sheep.sheepID else { return false }
        guard sheepID != "" else { return false }
        for lamb in sheep.lambs {
            guard let lambID = lamb.sheepID else { return false }
            guard lambID != "" else { return false }
            guard lamb.lambs == [] else { return false }
        }
        if let motherID = sheep.motherID {
            //guard let sheepID = motherSheep.sheepID else { return false }
            guard motherID != "" else { return false }
        }
        if let fatherID = sheep.fatherID {
            guard fatherID != "" else { return false }
        }
        
        return true
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Sheep(sheepID: sheepID, birthday: birthday, motherID: motherID, fatherID: fatherID)
        copy.notes = notes
        copy.lambs = lambs.map {$0.copy() as! Sheep}
        copy.biologicalMotherID = biologicalMotherID
        copy.female = female
        copy.assumedNumberOfLambs = assumedNumberOfLambs
        copy.ramID = ramID
        copy.groupMemberships = groupMemberships
        copy.weightings = weightings
        copy.earlierYears = earlierYears
        return copy
    }
    
    func setValues(equal sheep: Sheep){
        sheepID = sheep.sheepID
        birthday = sheep.birthday
        motherID = sheep.motherID
        fatherID = sheep.fatherID
        notes = sheep.notes
        lambs = sheep.lambs.map {$0.copy() as! Sheep}
        biologicalMotherID = sheep.biologicalMotherID
        female = sheep.female
        assumedNumberOfLambs = sheep.assumedNumberOfLambs
        ramID = sheep.ramID
        groupMemberships = sheep.groupMemberships
        weightings = sheep.weightings
        earlierYears = sheep.earlierYears
    }
    static func ==(lhs: Sheep, rhs: Sheep) -> Bool {
        return (lhs.sheepID == rhs.sheepID &&
            lhs.birthday == rhs.birthday &&
            lhs.motherID == rhs.motherID &&
            lhs.fatherID == rhs.fatherID &&
            lhs.notes == rhs.notes &&
            lhs.lambs.elementsEqual(rhs.lambs, by: {$0 == $1}) &&
            lhs.biologicalMotherID == rhs.biologicalMotherID &&
            lhs.female == rhs.female &&
            lhs.assumedNumberOfLambs == rhs.assumedNumberOfLambs &&
            lhs.ramID == rhs.ramID &&
            lhs.groupMemberships == rhs.groupMemberships &&
            lhs.weightings == rhs.weightings &&
            lhs.earlierYears == rhs.earlierYears)
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

