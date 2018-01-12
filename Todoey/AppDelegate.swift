//
//  AppDelegate.swift
//  Todoey
//
//  Created by Shadab Khan on 12/21/17.
//  Copyright © 2017 Shadab Khan. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        

        
        do{
            _ = try Realm()
        } catch {
            print("Error in installing new realm,\(error)")
        }
        
        return true
    }

//    func applicationWillResignActive(_ application: UIApplication) {
//
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//
//    }
//
//
//    func applicationWillTerminate(_ application: UIApplication) {
//
//        self.saveContext()
//    }
//
//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "DataModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }


}

