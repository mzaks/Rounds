//
//  AppDelegate.swift
//  Rounds
//
//  Created by Maxim Zaks on 20.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var link: CADisplayLink?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = mainReactiveLoop
        _ = appReactiveLoop
        
        mainLoop.initialise()
        
        setupLink()
        
        return true
    }
    
    func setupLink() {
        link = CADisplayLink(target: self, selector: #selector(tick))
        link?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc func tick() {
        mainLoop.execute()
        mainLoop.cleanup()
    }
}

