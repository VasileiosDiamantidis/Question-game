//
//  UserNumbers.swift
//  TwoPlayerQuestionGame
//
//  Created by Vasileios Diamantidis on 27/10/2017.
//  Copyright © 2017 vdiamant. All rights reserved.
//

import Foundation
import os.log
//import Firebase


class UserNumbers: NSObject, NSCoding{
    
    
    var categoryOneList = [Int]()
    var categoryTwoList = [Int]()
    
    var maximumNumber = 99
    
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirecctory = documentsDirectories.first!
        return documentDirecctory.appendingPathComponent("UserNumbers.archive")
    }()
    
    
    override init(){
        super.init()
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? UserNumbers{
            self.categoryOneList = archivedItems.categoryOneList
            self.categoryTwoList = archivedItems.categoryTwoList
            
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoryOneList, forKey: "catOne")
        aCoder.encode(categoryTwoList, forKey: "catTwo")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        categoryOneList = aDecoder.decodeObject(forKey: "catOne") as! [Int]
        categoryTwoList = aDecoder.decodeObject(forKey: "catTwo") as! [Int]
        
        super.init()
    }
    
    
    private func saveChanges() -> Bool{
        print("Saving items to: \(itemArchiveURL.path)}")
        return NSKeyedArchiver.archiveRootObject(self, toFile: itemArchiveURL.path)
    }
    
    
    
    public func getRandomNumber() -> Int{
        categoryOneList.removeAll()
        if((categoryOneList.count - 10) >= self.maximumNumber){
            categoryOneList.removeAll()
        }
        
        var myTmpInt:Int
        repeat{
            myTmpInt = Int(arc4random_uniform(99)+1)
        }while(self.categoryOneList.contains(myTmpInt))
    
        categoryOneList.append(myTmpInt)
        saveChanges()
        
        
        //Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            //AnalyticsParameterItemID: "randomNumber_\(myTmpInt)" as NSObject
            //])
        
        
        
        return myTmpInt
        
    
    }
    
    
    
    
    
    
}
    
    
    
    
    
    

