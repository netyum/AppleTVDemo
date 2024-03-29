//
//  AppDelegate.swift
//  AppleTVDemo
//
//  Created by Oleksii Ozun on 01.12.15.
//  Copyright © 2015 DataArt. All rights reserved.
//

import UIKit
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TVApplicationControllerDelegate {

    var window: UIWindow?
    
    var tvAppController: TVApplicationController?
    
    static let TVBaseURL = "http://localhost:8080/"
    
    static let TVBootURL = "\(AppDelegate.TVBaseURL)js/application.js"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let tvAppControllerContext = TVApplicationControllerContext()
        
        if let javaScriptURL = NSURL(string: AppDelegate.TVBootURL) {
            tvAppControllerContext.javaScriptApplicationURL = javaScriptURL
        }
        
        tvAppControllerContext.launchOptions["BASEURL"] = AppDelegate.TVBaseURL
        
        if let launchOptions = launchOptions as? [String: AnyObject] {
            for (kind, value) in launchOptions {
                tvAppControllerContext.launchOptions[kind] = value
            }
        }
        tvAppController = TVApplicationController(context: tvAppControllerContext, window: nil, delegate: self)

        if let root = window?.rootViewController as? RootViewController{
            root.tvAppController = tvAppController
        }
        
        return true
    }
    
    func appController(appController: TVApplicationController, evaluateAppJavaScriptInContext jsContext: JSContext) {
        
        let pushMyViewBlock : @convention(block) () -> Void = {
            () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let story = UIStoryboard(name: "Main", bundle: nil)
                let vc = story.instantiateViewControllerWithIdentifier("cast")
                self.tvAppController?.navigationController.pushViewController(vc, animated: true)
            })
        }

        jsContext.setObject(unsafeBitCast(pushMyViewBlock, AnyObject.self), forKeyedSubscript: "pushCastCollectionViewController")
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        print("Application launched with URL: \(url)")
        return true
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
    }


}

