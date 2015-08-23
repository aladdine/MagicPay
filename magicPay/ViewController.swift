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
  
  @IBOutlet var imgvQr:UIImageView? = UIImageView()

  var myBeaconRegion:CLBeaconRegion = CLBeaconRegion()
  var locationManager:CLLocationManager = CLLocationManager()
  @IBOutlet weak var tbView: UITableView!
  
  var logo = ["masters-of-code1.jpg","Logo_Tomorrowland.png","Logo","logo.png"]
  
  var name = ["Mastercard Masters of Code","Tomorrowland","Jurassic World @ AMC Metreon 16","California's Great America"]
  
  var mi = ["0","3.5","5.3","50"]

  func start() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    
    let uuid = NSUUID(UUIDString: "3E6857AF-11C7-44AD-837D-F3766E80520B")
    let uuid2 = NSUUID(UUIDString: "52414449-5553-4E45-5457-4F234B53434F")
    
    self.myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "GreatAmerica")
    
    //    self.locationManager.startMonitoringForRegion(self.myBeaconRegion)
    
    self.locationManager.startRangingBeaconsInRegion(self.myBeaconRegion)
    
  }
  
  func creditCardTokenFailedWithError(error: NSError!) {
    println(error)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  func creditCardTokenProcessed(token: SIMCreditCardToken!) {
    println("Credit Card token: \(token.token)")
    let token = token.token
    self.saveTokenToFirebase(token)
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isCreditCard")
    NSUserDefaults.standardUserDefaults().synchronize()
    
    self.dismissViewControllerAnimated(true, completion: nil)
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
  func chargeCardCancelled()
  {
    println("cancelled")
    self.dismissViewControllerAnimated(true, completion: nil)

  }
  
  override func viewDidAppear(animated: Bool) {
    if NSUserDefaults.standardUserDefaults().boolForKey("isCreditCard")
    {
      
    }
    else
    {
      var chargeVC = SIMChargeCardViewController(publicKey: "sbpb_ZDQ3ZjU3N2ItNWY5My00ZWU1LWI3NjUtMzNiMTQyMjc3NmVm")
      chargeVC.delegate = self
      self.presentViewController(chargeVC, animated: true, completion: nil)
    }
}

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.start()
    if let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    {
      self.imgvQr?.image = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=GreatAmerica%20-\(userID)")!)!)!
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    //2. Create a SIMChargeViewController with your public api key
    
    //3. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    
    //4. Add SIMChargeViewController to your view hierarchy
    
//    let authenticateButton = DGTAuthenticateButton(authenticationCompletion: {
//      (session: DGTSession!, error: NSError!) in
//      // play with Digits session
//      println("phone number: \(session.phoneNumber)")
//      println("User id: \(session.userID)")
//      
//      //Saving on NSUserDefaults
//      NSUserDefaults.standardUserDefaults().setValue(session.phoneNumber, forKey: "phoneNumber")
//      NSUserDefaults.standardUserDefaults().setValue(session.userID, forKey: "userID")
//      NSUserDefaults.standardUserDefaults().synchronize()
//      
//      
//      var myRootRef = Firebase(url:"https://magicpay.firebaseio.com")
//      // Write data to Firebase
//      var alanisawesome = ["full_name": "Alan Turing", "userID": session.userID]
//
//      var usersRef = myRootRef.childByAppendingPath("users")
//      
//      var users = [session.userID: alanisawesome]
//      usersRef.setValue(users)
//      
//      
//      // Write data to Firebase
//      var venue = ["full_name": "Great America", "venueID": "GreatAmerica","venuePrice":30]
//      
//      var venuesRef = myRootRef.childByAppendingPath("venues")
//      
//      var venues = ["GreatAmerica": venue]
//      venuesRef.setValue(venues)
//
////      var ref = Firebase(url: "https://magicpay.firebaseio.com")
////      var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
////      var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]
////      
////      var usersRef = ref.childByAppendingPath("users")
////      
////      var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
////      usersRef.setValue(users)
//      
//    })
//    authenticateButton.center = self.view.center
//    self.view.addSubview(authenticateButton)
    
//    let bc = IBeacon()
    // Create a NSUUID with the same UUID as the broadcasting beacon
    //    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    
    // Tell location manager to start monitoring for the beacon region
  }
//MARK: Delegate
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
        let dic = snapshot.value as! NSDictionary
        let token = dic["token"] as! String
        
        var not = UIAlertController(title: "Proximation detected", message: "Do you want to pay $\(price/100) for \(venueName)?", preferredStyle: UIAlertControllerStyle.Alert)
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
          self.chargeUserWithToken(token: token, amount: price, description: venueID)

        })
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: nil)
        not.addAction(yes)
        not.addAction(no)
        self.presentViewController(not, animated: true, completion: nil)

//        self.chargeUserWithToken(token: token, amount: price, description: venueID)
    
        println(snapshot.value)
        }, withCancelBlock: { error in
          println(error.description)
      })  }
      
      
      println(snapshot.value)
      }, withCancelBlock: { error in
        println(error.description)
    })  }
  
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
      
      let not = UIAlertController(title: "YAY", message: "Great America Ticket is Paid!", preferredStyle: UIAlertControllerStyle.Alert)
      let act = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
        self.parentViewController?.tabBarController?.selectedIndex = 2

      })
      not.addAction(act)

      self.presentViewController(not, animated: true, completion: nil)
    }
  }
  
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    println("Exited Beacon")
  }
  
}

