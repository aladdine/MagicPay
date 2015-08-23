//
//  LoginViewController.swift
//  magicPay
//
//  Created by Lucas Farah on 8/23/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit
import DigitsKit
import Firebase
class LoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurred-vision-iphone5wallpapersus_94701a116a4d9e9d39afa1f4cef46f13_raw.jpg")!)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func butLogin(sender: AnyObject)
  {
    let digits = Digits.sharedInstance()
    digits.authenticateWithCompletion { (session, error) in
      // Inspect session/error objects
      
      // play with Digits session
      println("phone number: \(session.phoneNumber)")
      println("User id: \(session.userID)")
      
      //Saving on NSUserDefaults
      NSUserDefaults.standardUserDefaults().setValue(session.phoneNumber, forKey: "phoneNumber")
      NSUserDefaults.standardUserDefaults().setValue(session.userID, forKey: "userID")
      NSUserDefaults.standardUserDefaults().synchronize()
      
      
      if NSUserDefaults.standardUserDefaults().boolForKey("isCreditCard")
      {
        
      }
      else
      {
        
        var myRootRef = Firebase(url:"https://magicpay.firebaseio.com")
        // Write data to Firebase
        var alanisawesome = ["full_name": "Alan Turing", "userID": session.userID]
        
        var usersRef = myRootRef.childByAppendingPath("users")
        
        var users = [session.userID: alanisawesome]
        usersRef.setValue(users)
        
        
        // Write data to Firebase
        var venue1 = ["full_name": "Great America", "venueID": "GreatAmerica","venuePrice":30]
        var venue2 = ["full_name": "Mastercard Masters Of Code", "venueID": "Masters","venuePrice":10]
        var venue3 = ["full_name": "TomorrowLand", "venueID": "Tomorrowland","venuePrice":500]
        var venue4 = ["full_name": "Jurassic World @ AMC Metron 16", "venueID": "JurassicWorld","venuePrice":15]
        
        var venuesRef = myRootRef.childByAppendingPath("venues")
        
        var venues = ["GreatAmerica": venue1,"Masters":venue2,"Tomorrowland":venue3,"JurassicWorld":venue4]
        venuesRef.setValue(venues)
      }
      let tab:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainNav") as! UITabBarController
      self.presentViewController(tab, animated: true, completion: nil)
      
    }
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
