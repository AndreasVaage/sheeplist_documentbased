//
//  ModelController.swift
//  SheepList
//
//  Created by Andreas Våge on 09.07.2017.
//
//

import UIKit


class ModelController{
    var document: SheepDocument?
    var sheeps: [Sheep] {return document?.sheepList?.sheeps ?? []}
    var workingSet: [Sheep] {return document?.sheepList?.workingSet ?? []}
    
    var everyOneByThemSelf: [Sheep] {
        var sheepList: [Sheep]  = sheeps
        for sheep in sheeps {
            sheepList.append(contentsOf: sheep.lambs)
        }
        return sheepList
    }
    
//    func findMissingSheeps() -> [Sheep]{
//        var missingSheeps = [Sheep]()
//        for sheep in workingSet{
//            if let mother = sheep.mother {
//                if !workingSet.contains(mother){
//                    missingSheeps.append(mother)
//                }
//            }
//        }
//        return missingSheeps
//    }
    func sheepIdIsUnique(_ ID: String?) -> Bool{
        return !(document?.sheepList?.allSheepAndLambIDs ?? []).contains(ID ?? "")
    }
    
    func findMissingLambs(list: [Sheep]) -> [Sheep] {
        var missingLambs = [Sheep]()
        for sheep in list{
            for lamb in sheep.lambs{
                if !workingSet.contains(lamb){
                    missingLambs.append(lamb)
                }
            }
        }
        return missingLambs
    }
    func countLambsInWorkingSet() -> Int{
        var count = 0
        for sheep in workingSet{
            if sheep.isLamb(){
                count += 1
            }
        }
        return count
    }
   // modelC.sheeps.sort(sortBasedOnMissing)
//    let sortBasedOnMissing = { (lhs: Sheep,rhs: Sheep) -> Bool in
//        if lhs.groupMemberships[2] && !rhs.groupMemberships[2]{
//            return true
//        }
//        var missingLamb = false
//        for lamb in lhs.lambs{
//            if lamb.groupMemberships[2] {
//                missingLamb = true
//                break
//            }
//        }
//        for lamb in rhs.lambs{
//            if lamb.groupMemberships[2] {
//                missingLamb = false
//                break
//            }
//        }
//
//        return missingLamb
//    }
    
    func delete(sheep: Sheep) {
        if let index = sheeps.index(of: sheep){
            document?.sheepList?.sheeps.remove(at: index)
            dataChanged()
        }else{
            fatalError("Trying to delete sheep which does not exist")
        }
    }
    
    func save(sheep: Sheep, sheepIndex: Int?, lambIndex: Int?) -> Bool{
        if document?.sheepList == nil {
            document?.sheepList = SheepList()
            print("\nCreated new Sheeplist")
        }
        guard document?.sheepList?.sheeps != nil else {return false}
        
        if let _ = sheepIndex {
            fatalError("Deprecated functionality")
            //if let lambIndex = lambIndex {
            //    document?.sheepList?.sheeps?[sheepIndex].lambs[lambIndex] = sheep
            //}else{
            //    document?.sheepList?.sheeps?[sheepIndex] = sheep
            //}
            
        }else{
            document?.sheepList?.sheeps.append(sheep)
        }
        dataChanged()
        return true
    }
    
    func dataChanged(){
        if document?.sheepList != nil {
            document?.updateChangeCount(.done)
        }else{
            print("No sheepList to change")
        }
    }
    
    func findLastSavedLambID() -> String? {
        for sheep in sheeps.reversed(){
            if let lambID = sheep.lambs.last?.sheepID {
                return lambID
            }
        }
        return nil
    }
}
