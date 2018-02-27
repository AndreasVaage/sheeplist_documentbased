//
//  Sheep.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 30.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit

class Sheep: NSObject {
    
    var sheepID: String?
    var birthday: Date?
    var notes: String?
    var lambs: [Sheep]
    var mother: Sheep?
    var biologicalMother: Sheep?
    var father: Sheep?
    var ram: Sheep?
    var assumedNumberOfLambs = 0
    var groupMemberships = [Group]()
    var female = true
    var weightings = [Weigthing(weight: 40.5)]
    
    var earlierYears = [Int:Sheep]()
    
    let lambPrefix = "70"
    
    init(sheepID: String?) {
        self.sheepID = sheepID
        self.lambs = []
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
    required init?(coder aDecoder: NSCoder) {
        sheepID = aDecoder.decodeObject(forKey: Keys.sheepID) as? String
        birthday = aDecoder.decodeObject(forKey: Keys.birthday) as? Date
        notes = aDecoder.decodeObject(forKey: Keys.notes) as? String
        lambs = aDecoder.decodeObject(forKey: Keys.lambs) as? [Sheep] ?? []
        mother = aDecoder.decodeObject(forKey: Keys.mother) as? Sheep
        biologicalMother = aDecoder.decodeObject(forKey: Keys.biologicalMother) as? Sheep
        father = aDecoder.decodeObject(forKey: Keys.father) as? Sheep
        ram = aDecoder.decodeObject(forKey: Keys.ram) as? Sheep
        if let assumedNumberOfLambs = aDecoder.decodeObject(forKey: Keys.assumedNumberOfLambs) as? Int {
            self.assumedNumberOfLambs = assumedNumberOfLambs
        }
        if let groupMemberships = aDecoder.decodeObject(forKey: Keys.groupMemberships) as? [Group] {
            self.groupMemberships = groupMemberships
        }
        if let female = aDecoder.decodeObject(forKey: Keys.female) as? Bool {
            self.female = female
        }
        if let weightings = aDecoder.decodeObject(forKey: Keys.weightings) as? [Weigthing]{
            self.weightings = weightings
        }
        if let earlierYears = aDecoder.decodeObject(forKey: Keys.earlierYears) as? [Int:Sheep]{
            self.earlierYears = earlierYears
        }
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
            lhs.mother == rhs.mother &&
            lhs.father == rhs.father &&
            lhs.notes == rhs.notes &&
            lhs.lambs.elementsEqual(rhs.lambs, by: {$0 == $1}) &&
            lhs.biologicalMother == rhs.biologicalMother &&
            lhs.female == rhs.female &&
            lhs.assumedNumberOfLambs == rhs.assumedNumberOfLambs &&
            lhs.ram == rhs.ram &&
            lhs.groupMemberships == rhs.groupMemberships &&
            lhs.weightings == rhs.weightings &&
            lhs.earlierYears == rhs.earlierYears)
    }
}

extension Sheep: NSCoding {
    struct Keys {
        static let sheepID = "sheepID"
        static let birthday = "birthday"
        static let notes = "notes"
        static let lambs = "lambs"
        static let mother = "mother"
        static let biologicalMother = "biologicalMother"
        static let father = "father"
        static let ram = "ram"
        static let assumedNumberOfLambs = "assumedNumberOfLambs"
        static let groupMemberships = "groupMemberships"
        static let female = "female"
        static let weightings = "weightings"
        static let earlierYears = "earlierYears"
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sheepID, forKey: Keys.sheepID)
        aCoder.encode(birthday, forKey: Keys.birthday)
        aCoder.encode(notes, forKey: Keys.notes)
        aCoder.encode(lambs, forKey: Keys.lambs)
        aCoder.encode(mother, forKey: Keys.mother)
        aCoder.encode(biologicalMother, forKey: Keys.biologicalMother)
        aCoder.encode(father, forKey: Keys.father)
        aCoder.encode(ram, forKey: Keys.ram)
        aCoder.encode(assumedNumberOfLambs, forKey: Keys.assumedNumberOfLambs)
        aCoder.encode(groupMemberships, forKey: Keys.groupMemberships)
        aCoder.encode(female, forKey: Keys.female)
        aCoder.encode(weightings, forKey: Keys.weightings)
        aCoder.encode(earlierYears, forKey: Keys.earlierYears)
    }
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
        copy.earlierYears = earlierYears
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
        earlierYears = sheep.earlierYears
    }
}

