//
//  AppDelegate.swift
//  HackerNews
//
//  Created by Alexander Ge on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

var requestPerformer: RequestPerformer?

struct Keys {
    static var favoritesPath: String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/profile.plist")
        return path
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    var listController: CharacterListController?
    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        if(!FileManager.default.fileExists(atPath: Keys.favoritesPath)){
//            let data: [String:String] = [:]
//            let nsData = NSDictionary(dictionary: data)
//            nsData.write(toFile: Keys.favoritesPath, atomically: true)
//        }
        
        // Setup Window
        let window = UIWindow()
        self.window = window
        
        requestPerformer = RequestPerformer()
        requestPerformer?.fetchTopItemIds { array in
//            guard let array = array else { return }
            requestPerformer?.fetchItemDetail(itemID: String(array.first!)) { item in
                requestPerformer?.fetchComment(commentID: String(item!.commentList.first!), successHandler: { (comment) in
                    
                })
            }
        }
        
//        window.rootViewController = controller
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        
        // start loading the results
//        listController = CharacterListController(navigationController: navigationController)
        
        return true
    }


}

