//
//  AppDelegate.swift
//  Trax
//
//  Created by CAOYE on 8/30/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

struct GPXURL {
    static let Notification = "GPXURL Radio Station"
    static let key = "GPXURL URL Key"
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        // post a notification when a GPX file arrives
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.key: url])
        center.postNotification(notification)
        return true
    }
}

