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
        return sheepList?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            if let sheepList = try? JSONDecoder().decode(SheepList.self, from: json) {
                self.sheepList = sheepList
            }else{
                self.sheepList = nil
            }
        }
    }
}

