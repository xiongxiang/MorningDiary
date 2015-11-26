//
//  CKManager.swift
//  Diary
//
//  Created by kevinzhow on 15/7/7.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import Foundation
import CloudKit

let container = CKContainer(identifier: icloudIdentifier())
let publicDB = container.publicCloudDatabase
let privateDB = container.privateCloudDatabase

func saveNewRecord(diary: Diary) {
    
    let newDiary = CKRecord(recordType: "Diary")
    debugPrint("Add New Diary To iCloud")
    updateRecord(diary, record: newDiary)
}

func updateRecord(diary: Diary, record: CKRecord) {
    
    record.setObject(diary.content, forKey: "Content")
    
    record.setObject(diary.created_at, forKey: "Created_at")
    
    if let location = diary.location {
        record.setObject(location, forKey: "Location")
    }
    
    if let title = diary.title {
        record.setObject(title, forKey: "Title")
    }
    
    record.setObject(diary.id, forKey: "id")
    
    privateDB.saveRecord(record, completionHandler: { (newDiary, error) -> Void in
        
        debugPrint("Diary Updated")
        
        if let error = error {
            debugPrint("error \(error.description)")
        }
        
    })
}

func fetchCloudRecordWithID(recordID: String , complete: (CKRecord?) -> Void) {
    
    let predicate = NSPredicate(format: "id == %@", recordID)
    
    let query = CKQuery(recordType: "Diary",
        predicate: predicate )
    
    privateDB.performQuery(query, inZoneWithID: nil) {
        results, error in
        if let results = results, record = results.first{
            complete(record)
        } else {
            complete(nil)
        }
    }
}

func deleteCloudRecord(record: CKRecord) {
    privateDB.deleteRecordWithID(record.recordID) { (recordID, error) -> Void in
        print("Delete \(recordID?.recordName) \(error?.description)")
    }
}

func fetchCloudRecordWithTitle(title: String , complete: ([CKRecord]?) -> Void) {
    
    let predicate = NSPredicate(format: "Title == %@", title)
    
    let query = CKQuery(recordType: "Diary",
        predicate: predicate )
    
    privateDB.performQuery(query, inZoneWithID: nil) {
        results, error in
        if let results = results {
            complete(results)
        } else {
            complete(nil)
        }
    }
}

func fetchCloudRecords(complete: ([CKRecord]?) -> Void) {
    
        let predicate = NSPredicate(value: true)
    
        let query = CKQuery(recordType: "Diary",
            predicate: predicate )

        privateDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            
            if let results = results{
                complete(results)
            } else {
                complete(nil)
            }
        }
}