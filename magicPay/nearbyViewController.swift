//
//  nearbyViewController.swift
//  Magicpass
//
//  Created by Noah Marriott on 8/23/15.
//  Copyright (c) 2015 Noah Marriott. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class nearbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,SIMChargeCardViewControllerDelegate {

    @IBOutlet weak var tbVIew: UITableView!
  
//    var logo = ["masters-of-code1.jpg","Logo_Tomorrowland.png","logo.png","Logo"]
//    var theName = ["Mastercard Masters of Code", "California's Great America"]
    var cat = ["Events", "Theme Parks","",""]
    var location = ["San Fransisco, CA", "Santa Clara, CA","San Fransisco, CA","San Fransisco, CA"]
  var logo = ["masters-of-code1.jpg","Logo_Tomorrowland.png","logo.png","Logo"]
  
  var theName = ["Mastercard Masters of Code","Tomorrowland","Jurassic World @ AMC Metreon 16","California's Great America"]
  
  var mi = ["0","3.5","5.3","50"]
  var lastProximity: CLProximity! = CLProximity.Unknown

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tbVIew.dequeueReusableCellWithIdentifier("theCell") as! nearbyTableViewCell
        
        var logoImg = UIImage(named: logo[indexPath.row])
      
        cell.logo.image = logoImg
        cell.Name.text = theName[indexPath.row]
        cell.cat.text = cat[indexPath.row]
        cell.city.text = location[indexPath.row]
        return cell
    }
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == 0
    {
      NSUserDefaults.standardUserDefaults().setObject("Mastercard Masters of Code", forKey: "title")
    }
    else if indexPath.row == 1
    {
      NSUserDefaults.standardUserDefaults().setObject("Tomorrowland", forKey: "title")
      
    }
    else if indexPath.row == 2
    {
      NSUserDefaults.standardUserDefaults().setObject("Jurassic World @ AMC", forKey: "title")
      
    }
    else if indexPath.row == 3
    {
      NSUserDefaults.standardUserDefaults().setObject("California's Great America", forKey: "title")
    }
    
    self.performSegueWithIdentifier("detail", sender: self)
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
      if (beacons.first != nil)
      {
        let nearestBeacon = beacons.first as! CLBeacon
        if(nearestBeacon.proximity == lastProximity! ||                     nearestBeacon.proximity == CLProximity.Unknown) {
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
      //      println(message)
    }
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
          
           if UIApplication.sharedApplication().applicationState.rawValue != 2
           {
            var not = UIAlertController(title: "Proximation detected", message: "Do you want to pay $\(price/100) for \(venueName)?", preferredStyle: UIAlertControllerStyle.Alert)
            let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
              self.chargeUserWithToken(token: token, amount: price, description: venueID)
              
            })
            let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: nil)
            not.addAction(yes)
            not.addAction(no)
            self.presentViewController(not, animated: true, completion: nil)
            
          }

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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
