//
//  blahUIViewController.swift
//
//
//  Created by Noah Marriott on 8/23/15.
//
//

import UIKit
import Firebase
import CoreLocation
class blahUIViewController: UIViewController,CLLocationManagerDelegate {
  
  @IBOutlet weak var tbView: UITableView!
  
  var logo = ["masters-of-code1.jpg","Logo_Tomorrowland.png","logo.png","Logo"]
  
  var name = ["Mastercard Masters of Code","Tomorrowland","Jurassic World @ AMC Metreon 16","California's Great America"]
  
  var mi = ["0","3.5","5.3","50"]
  
  @IBOutlet var imgvQr:UIImageView? = UIImageView()
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Nearby"
    
    self.start()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool)
  {
    let ref = Firebase(url:"https://magicpay.firebaseio.com/venues")
    ref.observeEventType(.Value, withBlock: { snapshot in
      
      //Venue
      let dic = snapshot.value as! NSDictionary
      
      for key in dic.allKeys
      {
        let place = dic["\(key)"] as! NSDictionary!
        let name = place["full_name"] as! String!
        let price = place["venuePrice"] as! Int!
        println("\(name) - $\(price)")
      }
//      let token = dic["token"] as! String
      
//      println(snapshot.value)
      }, withCancelBlock: { error in
        println(error.description)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return name.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tbView.dequeueReusableCellWithIdentifier("cellTwo") as! blahTableViewCell
    
    var logoImg = UIImage(named: logo[indexPath.row])
    
    cell.logoImg.image = logoImg
    
    cell.miNum.text = mi[indexPath.row]
    cell.placeName.text = name[indexPath.row]
    
    return cell
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
  
}
