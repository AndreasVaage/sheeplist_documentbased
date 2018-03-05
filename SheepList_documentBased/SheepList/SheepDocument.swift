//
//  SheepDocument.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 04.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit

class SheepDocument: UIDocument {
    var sheepList: SheepList?
    
    override func contents(forType typeName: String) throws -> Any {
        for sheep in sheepList?.sheeps ?? [] {
            sheep._biologicalMother = sheep.biologicalMother?.sheepID
            sheep._father = sheep.father?.father?.sheepID
            sheep._ram = sheep.ram?.sheepID
            for lamb in sheep.lambs{
                lamb._biologicalMother = lamb.biologicalMother?.sheepID
                lamb._father = lamb.father?.father?.sheepID
                lamb._ram = lamb.ram?.sheepID
            }
        }
        do {
            return try JSONEncoder().encode(sheepList)
        } catch  {
            print(error)
            return Data()
        }
    }
    
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let data = contents as? Data {
            sheepList = try? JSONDecoder().decode(SheepList.self, from: data)
            
            for sheep in sheepList?.sheeps ?? [] {
                sheep.biologicalMother = 
                sheep.father =
                sheep.ram = 
                for lamb in sheep.lambs{
                    lamb.mother = sheep
                }
            }
        }
    }
}

