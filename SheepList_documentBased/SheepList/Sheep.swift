//
//  Sheep.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 30.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit

class Sheep: NSObject, Codable {
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

