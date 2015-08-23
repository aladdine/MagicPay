//
//  AppDelegate.swift
//  magicPay
//
//  Created by Lucas Farah on 8/22/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

  var window: UIWindow?
  var myBeaconRegion:CLBeaconRegion = CLBeaconRegion()
  var locationManager: CLLocationManager?
  var lastProximity: CLProximity?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Fabric.with([Digits()])
    self.start()
    
    if(application.respondsToSelector("registerUserNotificationSettings:")) {
      application.registerUserNotificationSettings(
        UIUserNotificationSettings(
          forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
          categories: nil
        )
      )
    }
    
    var navigationBarAppearace = UINavigationBar.appearance()
    
    navigationBarAppearace.tintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)
    navigationBarAppearace.barTintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)
    
    
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBar.appearance().tintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)

//    let bc = IBeacon()
//    bc.start()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.start()
  }
  
  func sendLocalNotificationWithMessage(message: String!) {
    let notification:UILocalNotification = UILocalNotification()
    notification.alertBody = message
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
  
  
  
  func start() {
    locationManager = CLLocationManager()
    locationManager!.delegate = self
    locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager!.requestAlwaysAuthorization()
    locationManager!.pausesLocationUpdatesAutomatically = false

    let uuid = NSUUID(UUIDString: "3E6857AF-11C7-44AD-837D-F3766E80520B")
    let uuid2 = NSUUID(UUIDString: "52414449-5553-4E45-5457-4F234B53434F")
    
    self.myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "com.GreatAmerica")
    
    //    self.locationManager.startMonitoringForRegion(self.myBeaconRegion)
    
    self.locationManager!.startRangingBeaconsInRegion(self.myBeaconRegion)
    self.locationManager!.startMonitoringForRegion(self.myBeaconRegion)
    self.locationManager!.startUpdatingLocation()

    
  }
  
  func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
    println("Failed")
  }
  func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
    println("Beacon Found")
    
    println(region.identifier)
  }
  func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
    //    println("Beacon Found")
    //    println(beacons.first)
    let nearestBeacon: AnyObject? = beacons.first

    if (beacons.first != nil)
    {
      let nearestBeacon = beacons.first as! CLBeacon
      if(nearestBeacon.proximity == lastProximity ||
        nearestBeacon.proximity == CLProximity.Unknown) {
          return;
      }
      lastProximity = nearestBeacon.proximity;
      
      var message = ""
      
      switch nearestBeacon.proximity {
      case CLProximity.Far:
        message = "Proximity: Far"
      case CLProximity.Near:
        message = "Proximity: Near"
      case CLProximity.Immediate:
        message = "Proximity: Immediate"
        self.beaconDidApprox(beacon: nearestBeacon, forRegion: region)
      case CLProximity.Unknown:
        return
      }
      sendLocalNotificationWithMessage(message)

      //      println(message)
    }
  }
  
  func beaconDidApprox(#beacon:CLBeacon, forRegion region: CLRegion)
  {
    println("beaconID: \(region.identifier)")
    if let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    {
      println("userID: \(userID)")
    }
  }
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    println("Exited Beacon")
  }
  



}

