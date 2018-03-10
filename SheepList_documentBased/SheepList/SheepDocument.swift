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

        sheepList?.sheeps.forEach({(key,sheep) in
            sheep._biologicalMotherID = sheep.biologicalMother?.sheepID
            sheep._fatherID = sheep.father?.sheepID
            sheep._ramID = sheep.ram?.sheepID
            sheep._motherID = sheep.mother?.sheepID
            sheep._lambIDs = sheep.lambs.map{$0.sheepID!}
        })
        sheepList?.workingSet.forEach({(key,sheep) in
            self.sheepList?._workingSet.insert(sheep.sheepID!)
        })
        
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
            
            sheepList?.sheeps.forEach({(key,sheep) in
                if let _biologicalMotherID = sheep._biologicalMotherID{
                    sheep.biologicalMother = self.sheepList?.sheeps[_biologicalMotherID]
                }
                if let _fatherID = sheep._fatherID{
                    sheep.father = self.sheepList?.sheeps[_fatherID]
                }
                if let _ramID = sheep._ramID{
                    sheep.ram = self.sheepList?.sheeps[_ramID]
                }
                if let _motherID = sheep._motherID{
                    sheep.mother = self.sheepList?.sheeps[_motherID]
                }
                sheep.lambs = sheep._lambIDs.flatMap({(self.sheepList?.sheeps[$0])})
                
            })
            self.sheepList?.workingSet = [:]
            sheepList?._workingSet.forEach({sheepID in
                self.sheepList?.workingSet[sheepID] = self.sheepList?.sheeps[sheepID]
            })
            
        }
    }
}

