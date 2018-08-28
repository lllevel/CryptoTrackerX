//
//  AppDelegate.swift
//  ToTheMoon
//
//  Created by Шевель on 12.07.2018.
//  Copyright © 2018 ShevelAA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var enableAllOrientation = false

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if (enableAllOrientation == true){
//            return UIInterfaceOrientationMask.allButUpsideDown
//        }
        return UIInterfaceOrientationMask.portrait
    }
}

