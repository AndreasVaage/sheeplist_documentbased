//
//  SheepList.swift
//  SheepList
//
//  Created by Andreas Våge on 21.06.2017.
//
//

import UIKit

class SheepList: Codable{
    enum CodingKeys: String, CodingKey
    {
        case sheeps
        //case workingSet
        case _workingSet
        case groups
    }
    var year = 2018
    var sheeps = Set<Sheep>()
    var workingSet = Set<Sheep>()
    var _workingSet = Set<String>()
    var groups = [
        Group("orphan",.blue),Group("dead",.red),
        Group("missing",.gray),Group("sold",.green),
        Group("k",.yellow),Group("test",.purple),
        Group("testing",.orange),Group("tes",.cyan)]
    
    var allSheepAndLambIDs: [String] {
        var allIDs = [String]()
        for sheep in sheeps {
            allIDs.append(sheep.sheepID!)
            for lamb in sheep.lambs{
                allIDs.append(lamb.sheepID!)
            }
        }
        return allIDs
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

struct Group: Codable, Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.title == rhs.title && lhs._color == rhs._color
    }
    
    var title: String
    var color: UIColor {return UIColor(hexString: _color)}
    var popularity = 0
    var _color: String
    init(_ group: String, _ color: UIColor) {
        self.title = group
        self._color = color.toHexString()
    }
    
    mutating func increasePopularity() {
        popularity += 1
    }
}

// Allow simple json storage of UIColor as string
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

