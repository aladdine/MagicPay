//
//  blahUIViewController.swift
//
//
//  Created by Noah Marriott on 8/23/15.
//
//

import UIKit
import Firebase

class blahUIViewController: UIViewController {
  
  @IBOutlet weak var tbView: UITableView!
  
  var logo = ["masters-of-code1.jpg","Logo","Logo_Tomorrowland.png","logo.png","Logo"]
  
  var name = ["Mastercard Masters of Code","Tomorrowland","Jurassic World @ AMC Metreon 16","California's Great America"]
  
  var mi = ["0","3.5","5.3","50.7"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Nearby"
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
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
