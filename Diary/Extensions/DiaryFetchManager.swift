//
//  DiaryFetchManager.swift
//  Diary
//
//  Created by zhowkevin on 15/10/5.
//  Copyright © 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreData

extension MainViewController {
    
    
    func prepareFetch() {
        if let interfaceType = interfaceType {
            
            switch interfaceType {
            case .Home:
                
                let fetchRequest = NSFetchRequest(entityName:"Diary")
                
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
                if let managedContext = DiaryCoreData.sharedInstance.managedContext {
                    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                        managedObjectContext: managedContext, sectionNameKeyPath: "year",
                        cacheName: nil)
                }
            case .Year:
                let fetchRequest = NSFetchRequest(entityName:"Diary")
                fetchRequest.predicate = NSPredicate(format: "year = \(year)")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
                if let managedContext = DiaryCoreData.sharedInstance.managedContext {
                    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                        managedObjectContext: managedContext, sectionNameKeyPath: "month",
                        cacheName: nil)
                    fetchedResultsController.delegate = self
                }
            case .Month:
                let fetchRequest = NSFetchRequest(entityName:"Diary")
                
                debugPrint("year = \(year) AND month = \(month)")
                
                fetchRequest.predicate = NSPredicate(format: "year = \(year) AND month = \(month)")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
                if let managedContext = DiaryCoreData.sharedInstance.managedContext {
                    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                        managedObjectContext: managedContext, sectionNameKeyPath: "year",
                        cacheName: nil)
                    
                    fetchedResultsController.delegate = self
                }
            }
            
        }
        
        refetch()
    }
    
    func refetch() {
        
        if let interfaceType = interfaceType {
            
            switch interfaceType {
            case .Home:
                homeFetch()
            case .Year:
                yearFetch()
            case .Month:
                monthFetch()
            }
            
        }
        
    }
    
    func monthFetch() {
        
        do {
            try fetchedResultsController.performFetch()
            
            let fetchedResults = fetchedResultsController.fetchedObjects as! [NSManagedObject]
            if (fetchedResults.count == 0){
                NSLog("Present empty year")
            }else{
                
                diarys = fetchedResults
            }
            
        } catch _ {
            
        }
        
    }
    
    func homeFetch() {
        do {
            try fetchedResultsController.performFetch()
            
            let fetchedResults = fetchedResultsController.fetchedObjects as! [NSManagedObject]
            
            if (fetchedResults.count == 0){
                debugPrint("Present empty year")
            }else{
                
                if let sectionsCount = fetchedResultsController.sections?.count {
                    
                    yearsCount = sectionsCount
                    diarys = fetchedResults
                    
                }else {
                    sectionsCount = 0
                    yearsCount = 1
                }
            }
            
            moveToThisMonth()
        } catch _ {
            
        }
    }
    
    func yearFetch() {
        
        do {
            try fetchedResultsController.performFetch()
            
            let fetchedResults = fetchedResultsController.fetchedObjects as! [NSManagedObject]
            if (fetchedResults.count == 0){
                NSLog("Present empty year")
            }else{
                
                diarys = fetchedResults
            }
            
        } catch _ {
            
        }
    }
    
}
