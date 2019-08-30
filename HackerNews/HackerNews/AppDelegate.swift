//
//  AppDelegate.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var listController: ItemListController?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup Window
        let window = UIWindow()
        self.window = window
        
        listController = ItemListController(navigationController: navigationController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
}
