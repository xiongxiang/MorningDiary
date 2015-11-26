//
//  DiaryCloud.swift
//  Diary
//
//  Created by kevinzhow on 15/5/2.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class DiaryCloud: NSObject {
    static let sharedInstance = DiaryCloud()
    
    var fetchedResultsController : NSFetchedResultsController!
    
    override init() {
        
        super.init()
        
        let fetchRequest = NSFetchRequest(entityName:"Diary")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        
        if let managedContext = DiaryCoreData.sharedInstance.managedContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: managedContext, sectionNameKeyPath: nil,
                cacheName: nil)
            
            fetchedResultsController.delegate = self
        }
    }
    
    func startFetch() {
        
        do {
            try fetchedResultsController.performFetch()
            let fetchedResults = fetchedResultsController.fetchedObjects as! [Diary]
            debugPrint("All Diary is \(fetchedResults.count)")
            startSync()
        } catch _ {
            
        }
    }
    
    func startSync() {
        
        debugPrint("New sync")
        
        let allRecords  = fetchedResultsController.fetchedObjects as! [Diary]
        
        fetchCloudRecords { [weak self] records  in
            
            print(records?.count)
            print(allRecords.count)
            
            if let records = records {
                
                for fetchRecord in records {
                    
                    // Find Cloud Thing in Local
                    
                    if let diaryID = fetchRecord.objectForKey("id") as? String,
                        title = fetchRecord.objectForKey("Title") as? String{
                        
                        debugPrint("Processing \(diaryID) \(title)")
                        
                        if let _ = fetchDiaryByID(diaryID) {
                            debugPrint("No need to do thing")
                        } else {
                            debugPrint("Create Diary With CKRecords")
                            saveDiaryWithCKRecord(fetchRecord)
                        }
                    }
                }
                
                for record in allRecords {
                    //Find local in Cloud
                    
                    let filterArray = records.filter { cloud_record -> Bool in

                        if let recordID = cloud_record.objectForKey("id") as? String, title = cloud_record.objectForKey("Title") as? String {
                            
                            if recordID == record.id {
                                
                                debugPrint("OK Processing \(recordID) \(title)")
                                
                                return true
                                
                            } else {
                                
                                return false
                            }
                            
                        } else {
                            return true
                        }
                    }
                    
                    if filterArray.count == 0 {

                        if let _ = record.title {
                            saveNewRecord(record)
                        }
                        
                    } else {
                        debugPrint("No need to upload")
                    }
                    
                }
            }
            
            do {
                try DiaryCoreData.sharedInstance.managedContext?.save()
            } catch _ {
                
            }
            
            self?.removeDupicated()
        }
    }
    
    func removeDupicated() {
        let allRecords  = fetchedResultsController.fetchedObjects as! [Diary]
        
        for record in allRecords {
            
            guard let recordID = record.id else {
                return
            }
            
//            fetchCloudRecordWithTitle(recordID, complete: { (records) -> Void in
//                guard let records = records else {
//                    return
//                }
//                for record in records {
//                    deleteCloudRecord(record)
//                }
//
//            })
            
            var toDelete = [Diary]()
            
            if let fetchedRecords = fetchsDiaryByID(recordID) {
                for (index, fetchedRecord) in fetchedRecords.enumerate() {
                    if index != 0 {
                        
                        toDelete.append(fetchedRecord)
                    }
                }
            }
            
            for diary in toDelete {
                DiaryCoreData.sharedInstance.managedContext?.deleteObject(diary)
            }
        }
        
        do {
            try DiaryCoreData.sharedInstance.managedContext?.save()
        } catch _ {
            
        }
        
    }

}


func saveDiaryWithCKRecord(record: CKRecord) {
    if let managedContext = DiaryCoreData.sharedInstance.managedContext {
        
        let entity =  NSEntityDescription.entityForName("Diary", inManagedObjectContext: managedContext)

        if let ID = record.objectForKey("id") as? String,
            Content = record.objectForKey("Content") as? String,
            Location = record.objectForKey("Location") as? String,
            Title = record.objectForKey("Title") as? String,
            Date = record.objectForKey("Created_at") as? NSDate {
                
                let newdiary = Diary(entity: entity!,
                    insertIntoManagedObjectContext:managedContext)
                
                newdiary.id = ID
                
                newdiary.content = Content
                
                newdiary.location = Location
                
                newdiary.title = Title
                
                newdiary.updateTimeWithDate(Date)
        }
        
        do {
            try managedContext.save()
        } catch _ {
        }
    }
}

func fetchDiaryByID(id: String) -> Diary? {
    
    let fetchRequest = NSFetchRequest(entityName:"Diary")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    
    do {
        let fetchedResults =
        try DiaryCoreData.sharedInstance.managedContext?.executeFetchRequest(fetchRequest) as? [Diary]
        
        if let results = fetchedResults {
            return results.first
        } else {
            return nil
        }
    } catch _ {
        return nil
    }

}

func fetchsDiaryByID(id: String) -> [Diary]? {
    
    let fetchRequest = NSFetchRequest(entityName:"Diary")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    
    do {
        let fetchedResults =
        try DiaryCoreData.sharedInstance.managedContext?.executeFetchRequest(fetchRequest) as? [Diary]
        
        if let results = fetchedResults {
            return results
        } else {
            return nil
        }
    } catch _ {
        return nil
    }
    
}


func fetchsDiaryByTitle(title: String) -> [Diary]? {
    
    let fetchRequest = NSFetchRequest(entityName:"Diary")
    fetchRequest.predicate = NSPredicate(format: "title = %@", title)
    
    do {
        let fetchedResults =
        try DiaryCoreData.sharedInstance.managedContext?.executeFetchRequest(fetchRequest) as? [Diary]
        
        if let results = fetchedResults {
            return results
        } else {
            return nil
        }
    } catch _ {
        return nil
    }
    
}

extension DiaryCloud: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {

    }
}