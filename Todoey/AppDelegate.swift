//
//  AppDelegate.swift
//  Todoey
//
//  Created by Luca Favaron on 19/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // REALM
        do {
            _ = try Realm()
        } catch {
            print("Errore nel inisiaisar REALM \n \(error)")
        }
        
        return true
    }

}

