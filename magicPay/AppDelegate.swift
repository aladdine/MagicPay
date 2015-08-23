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
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
  
  var window: UIWindow?
  var myBeaconRegion:CLBeaconRegion = CLBeaconRegion()
  var locationManager: CLLocationManager?
  var lastProximity: CLProximity?
  var alreadyPushed = false

  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Fabric.with([Digits()])
    self.start()
    
//    let domain = NSBundle.mainBundle().bundleIdentifier
//    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(domain!)


    
    //NOTIFICATIONS
    var justInformAction = UIMutableUserNotificationAction()
    justInformAction.identifier = "yes"
    justInformAction.title = "Yes"
    justInformAction.activationMode = UIUserNotificationActivationMode.Background
    justInformAction.destructive = false
    justInformAction.authenticationRequired = false
    
    
    var trashAction = UIMutableUserNotificationAction()
    trashAction.identifier = "no"
    trashAction.title = "No"
    trashAction.activationMode = UIUserNotificationActivationMode.Background
    trashAction.destructive = true
    trashAction.authenticationRequired = false
    
    // Specify the category related to the above actions.
    var shoppingListReminderCategory = UIMutableUserNotificationCategory()
    shoppingListReminderCategory.identifier = "shoppingListReminderCategory"
    shoppingListReminderCategory.setActions([justInformAction,trashAction], forContext: UIUserNotificationActionContext.Default)
    shoppingListReminderCategory.setActions([justInformAction,trashAction], forContext: UIUserNotificationActionContext.Minimal)
    
    
    if(application.respondsToSelector("registerUserNotificationSettings:")) {
      application.registerUserNotificationSettings(
        UIUserNotificationSettings(
          forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
          categories: [shoppingListReminderCategory]
        )
      )
    }
    
    var navigationBarAppearace = UINavigationBar.appearance()
    
    navigationBarAppearace.tintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)
    navigationBarAppearace.barTintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)
    
    
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBar.appearance().tintColor = UIColor(red:0.85, green:0.55, blue:0.19, alpha:1.0)
    
    
    
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
    notification.category = "shoppingListReminderCategory"
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
    
    self.myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "GreatAmerica")
    
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
    
    if (beacons.first != nil)
    {
      let nearestBeacon = beacons.first as! CLBeacon
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
    
    let ref = Firebase(url:"https://magicpay.firebaseio.com/venues/\(region.identifier)")
    ref.observeEventType(.Value, withBlock: { snapshot in
      
      //Venue
      let dic = snapshot.value as! NSDictionary
      let venueID = dic["venueID"] as! String
      let venueName = dic["full_name"] as! String
      var price = dic["venuePrice"] as! Int
      price = price * 100 //in cents
      
      //User
      if let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
      {
        let ref = Firebase(url:"https://magicpay.firebaseio.com/users/\(userID)")
        ref.observeEventType(.Value, withBlock: { snapshot in
          
          //Venue
          var dic = snapshot.value as! NSMutableDictionary
          dic["venueID"] = venueID
          dic["price"] = price
          let token = dic["token"] as! String
          
          //Preventing multiple notif
          if self.alreadyPushed == false
          {
          let notification:UILocalNotification = UILocalNotification()
          notification.alertTitle = "Proximation detected"
          notification.alertBody = "Do you want to pay $\(price/100) for \(venueName)?"
          notification.category = "shoppingListReminderCategory"
          notification.userInfo = dic as [NSObject : AnyObject]
          notification.soundName = "default"
          UIApplication.sharedApplication().scheduleLocalNotification(notification)
          self.alreadyPushed = true
          }
          
          println(snapshot.value)
          }, withCancelBlock: { error in
            println(error.description)
        })  }
      
      
      println(snapshot.value)
      }, withCancelBlock: { error in
        println(error.description)
    })
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    println(identifier)
    if identifier == "no"
    {
      return
    }
    println(notification)
    let userInfo = notification.userInfo as NSDictionary!
    
    println(userInfo)
    let token = userInfo["token"] as! String
    let amount = userInfo["price"] as! Int
    let description = userInfo["venueID"] as! String
    self.chargeUserWithToken(token: token, amount: amount, description: description)
  }


func chargeUserWithToken(#token: String,amount: Int,description: String)
{
  let data = NSMutableData()
  let urlPath: String = "http://getthepowertools.com/MagicPay/magicpay.php?token=\(token)&amount=\(amount)&description=\(description)"
  var url: NSURL = NSURL(string: urlPath)!
  var request = NSMutableURLRequest(URL: url)
  var request1: NSURLRequest = NSURLRequest(URL: url)
  var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?
  >=nil
  var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
  var err: NSErrorPointer
  let string = NSString(data: dataVal, encoding: NSUTF8StringEncoding)
  if let str = string
  {
    println("Server Response: \(str)")
    
    
    let notification:UILocalNotification = UILocalNotification()
    notification.alertTitle = "Proximation detected"
    notification.alertBody = "YAY! Great America Ticket is Paid!"
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
  }
}
}


