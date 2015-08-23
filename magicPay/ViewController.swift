//
//  ViewController.swift
//  magicPay
//
//  Created by Lucas Farah on 8/22/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit
import DigitsKit
import CoreLocation
import Firebase
class ViewController: UIViewController,CLLocationManagerDelegate,SIMChargeCardViewControllerDelegate {
  
  var myBeaconRegion:CLBeaconRegion = CLBeaconRegion()
  var locationManager:CLLocationManager = CLLocationManager()
  
  
  func start() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    
    let uuid = NSUUID(UUIDString: "3E6857AF-11C7-44AD-837D-F3766E80520B")
    let uuid2 = NSUUID(UUIDString: "52414449-5553-4E45-5457-4F234B53434F")

    self.myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "com.GreatAmerica")

//    self.locationManager.startMonitoringForRegion(self.myBeaconRegion)
    
    self.locationManager.startRangingBeaconsInRegion(self.myBeaconRegion)

  }
  
  func creditCardTokenFailedWithError(error: NSError!) {
    println(error)
  }
  func creditCardTokenProcessed(token: SIMCreditCardToken!) {
    println("Credit Card token: \(token.token)")
    let token = token.token
    self.saveTokenToFirebase(token)
  }
  
  func saveTokenToFirebase(token: String)
  {
    if let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    {
      var myRootRef = Firebase(url:"https://magicpay.firebaseio.com")
      // Write data to Firebase
      var alanisawesome = ["full_name": "Alan Turing", "userID": userID,"token":token]
      
      var usersRef = myRootRef.childByAppendingPath("users")
      
      var users = [userID as NSString!: alanisawesome]
      usersRef.setValue(users)
      
    }
   self.dismissViewControllerAnimated(true, completion: nil)
  }
  func chargeCardCancelled() {
    println("cancelled")
  }
  
  override func viewDidAppear(animated: Bool) {
    var chargeVC = SIMChargeCardViewController(publicKey: "sbpb_ZDQ3ZjU3N2ItNWY5My00ZWU1LWI3NjUtMzNiMTQyMjc3NmVm")
    chargeVC.delegate = self
    self.presentViewController(chargeVC, animated: true, completion: nil)

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //2. Create a SIMChargeViewController with your public api key
    
    //3. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    
    //4. Add SIMChargeViewController to your view hierarchy
    
    let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
      (session: DGTSession!, error: NSError!) in
      // play with Digits session
      println("phone number: \(session.phoneNumber)")
      println("User id: \(session.userID)")
      
      //Saving on NSUserDefaults
      NSUserDefaults.standardUserDefaults().setValue(session.phoneNumber, forKey: "phoneNumber")
      NSUserDefaults.standardUserDefaults().setValue(session.userID, forKey: "userID")
      NSUserDefaults.standardUserDefaults().synchronize()
      
      
      var myRootRef = Firebase(url:"https://magicpay.firebaseio.com")
      // Write data to Firebase
      var alanisawesome = ["full_name": "Alan Turing", "userID": session.userID]

      var usersRef = myRootRef.childByAppendingPath("users")
      
      var users = [session.userID: alanisawesome]
      usersRef.setValue(users)
//      var ref = Firebase(url: "https://magicpay.firebaseio.com")
//      var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
//      var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
//      
//      var usersRef = ref.childByAppendingPath("users")
//      
//      var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
//      usersRef.setValue(users)
      
    })
    authenticateButton.center = self.view.center
    self.view.addSubview(authenticateButton)
    
    self.start()
    // Create a NSUUID with the same UUID as the broadcasting beacon
    //    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    
    // Tell location manager to start monitoring for the beacon region
  }
  //MARK: LocationManager Delegate
  
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
  }
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    println("Exited Beacon")
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

