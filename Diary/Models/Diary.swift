//
//  Diary.swift
//  
//
//  Created by kevinzhow on 15/7/7.
//
//

import Foundation
import CoreData

@objc(Diary) // 本文件是CoreData文件创建了之后导出来的。为了能够在Swift中正常使用，所以添加了一个@objc(Diary)标识。

class Diary: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var created_at: NSDate
    @NSManaged var location: String?
    @NSManaged var month: NSNumber
    @NSManaged var title: String?
    @NSManaged var year: NSNumber
    @NSManaged var id: String?

}
