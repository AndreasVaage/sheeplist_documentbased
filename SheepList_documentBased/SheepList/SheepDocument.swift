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
        
        sheepList?.sheeps.forEach({sheep in
            sheep._biologicalMotherID = sheep.biologicalMother?.sheepID
            sheep._fatherID = sheep.father?.father?.sheepID
            sheep._ramID = sheep.ram?.sheepID
            sheep._motherID = sheep.mother?.sheepID
            sheep._lambIDs = sheep.lambs.map{$0.sheepID!}
        })
        sheepList?.workingSet.forEach({sheep in
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
            
            sheepList?.sheeps.forEach({sheep in
                sheep.biologicalMother = self.sheepList?.sheeps.first(where: {$0.sheepID == sheep._biologicalMotherID})
                sheep.father = self.sheepList?.sheeps.first(where: {$0.sheepID == sheep._fatherID})
                sheep.ram = self.sheepList?.sheeps.first(where: {$0.sheepID == sheep._ramID})
                sheep.mother = self.sheepList?.sheeps.first(where: {$0.sheepID == sheep._motherID})
                sheep.lambs = (self.sheepList?.sheeps.filter({sheep._lambIDs.contains($0.sheepID!)}))!
            })
            
            sheepList?._workingSet.forEach({sheepID in
                self.sheepList?.workingSet.insert((self.sheepList?.sheeps.first(where: {$0.sheepID! == sheepID}))!)
            })
            
        }
    }
}

