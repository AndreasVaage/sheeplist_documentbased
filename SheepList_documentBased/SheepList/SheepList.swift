//
//  SheepList.swift
//  SheepList
//
//  Created by Andreas Våge on 21.06.2017.
//
//

import UIKit

class SheepList: NSObject, NSCoding{
    struct Keys {
        static let year = "year"
        static let sheeps = "sheeps"
        static let workingSet = "workingSet"
        static let groups = "groups"
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(year, forKey: Keys.year)
        aCoder.encode(sheeps, forKey: Keys.sheeps)
        aCoder.encode(workingSet, forKey: Keys.workingSet)
        aCoder.encode(groups, forKey: Keys.groups)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let year = aDecoder.decodeObject(forKey: Keys.year) as? Int{
            self.year = year
        }
        sheeps = aDecoder.decodeObject(forKey: Keys.sheeps) as? [Sheep]
        
        if let workingSet = aDecoder.decodeObject(forKey: Keys.workingSet) as? [Sheep] {
            self.workingSet = workingSet
        }
        if let groups = aDecoder.decodeObject(forKey: Keys.groups) as? [Group] {
            self.groups = groups
        }
    }
    
    var year = 2018
    var sheeps: [Sheep]?
    var workingSet = [Sheep]()
    var groups = [
        Group("orphan",.blue),Group("dead",.red),
        Group("missing",.gray),Group("sold",.green),
        Group("k",.yellow),Group("test",.purple),
        Group("testing",.orange),Group("tes",.cyan)]
    
    override init() {
        super.init()
        sheeps = [Sheep]()
    }
    
    var allSheepAndLambIDs: [String] {
        var allIDs = [String]()
        for sheep in sheeps ?? [] {
            allIDs.append(sheep.sheepID!)
            for lamb in sheep.lambs{
                allIDs.append(lamb.sheepID!)
            }
        }
        return allIDs
    }
    
    var data: Data? {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    func getMostImportentGroupColor(for sheep: Sheep) -> UIColor?{
        if sheep.groupMemberships == []{
            return nil
        }
        for group in groups {
            if sheep.groupMemberships.contains(group) {
                return group.color
            }
        }
        return nil
    }
}

class Group: NSCoding, Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.title == rhs.title && lhs.color == rhs.color
    }
    var title: String
    var color: UIColor
    var popularity = 0
    
    init(_ title: String, _ color: UIColor) {
        self.title = title
        self.color = color
    }
    
    func increasePopularity() {
        popularity += 1
    }
    
    struct Keys {
        static let title = "title"
        static let color = "color"
        static let popularity = "popularity"
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(color, forKey: Keys.color)
        aCoder.encode(popularity, forKey: Keys.popularity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: Keys.title) as! String
        self.color = aDecoder.decodeObject(forKey: Keys.color) as! UIColor
        if let popularity = aDecoder.decodeObject(forKey: Keys.popularity) as? Int {
            self.popularity = popularity
        }
    }
}

// Allow simple json storage of UIColor as string
//extension UIColor {
//    convenience init(hexString: String, alpha: CGFloat = 1.0) {
//        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        let scanner = Scanner(string: hexString)
//        if (hexString.hasPrefix("#")) {
//            scanner.scanLocation = 1
//        }
//        var color: UInt32 = 0
//        scanner.scanHexInt32(&color)
//        let mask = 0x000000FF
//        let r = Int(color >> 16) & mask
//        let g = Int(color >> 8) & mask
//        let b = Int(color) & mask
//        let red   = CGFloat(r) / 255.0
//        let green = CGFloat(g) / 255.0
//        let blue  = CGFloat(b) / 255.0
//        self.init(red:red, green:green, blue:blue, alpha:alpha)
//    }
//    func toHexString() -> String {
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//        return String(format:"#%06x", rgb)
//    }
//}

