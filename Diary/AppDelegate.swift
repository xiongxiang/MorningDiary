//
//  AppDelegate.swift
//  Diary
//
//  Created by kevinzhow on 15/2/11.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import MonkeyKing

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate{

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.applicationSupportsShakeToEdit = true
        
        Fabric.with([Crashlytics.self()])
        
        MonkeyKing.registerAccount(.WeChat(appID: "wx1f683ed6cec8c820"))

        if let _ = NSFileManager.defaultManager().ubiquityIdentityToken {
            // iCloud is available
            DiaryCloud.sharedInstance.startFetch()
            
            defaults.setObject(true, forKey: "defaultCloudConfig")
            
        } else {
            debugPrint("No iCloud")
            
            let message = UIAlertView(title: "iCloud 未开启", message: "为了备份您的数据，请在系统设置里登录 iCloud 以免发生记录丢失", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "好的")
            message.show()
            
            defaults.setObject(false, forKey: "defaultCloudConfig")
        }
        
        defaultConfig()
        
        return true
    }
    
    func defaultConfig() {
        
        if let _ = defaults.objectForKey("defaultConfig") {
            debugPrint("Configed")
        }else{
            defaults.setObject(currentLanguage == "ja" ? janpan : firstFont, forKey: "defaultFont")
            
            defaults.setObject(firstFont, forKey: "firstFont")
            defaults.setObject(secondFont, forKey: "secondFont")
            defaults.setObject(janpan, forKey: "japan")
            defaults.setObject(true, forKey: "defaultConfig")
            
        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DiaryCoreData.sharedInstance.saveContext()
    }

    

}

