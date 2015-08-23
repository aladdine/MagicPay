//
//  wooViewController.swift
//  Magicpass
//
//  Created by Noah Marriott on 8/23/15.
//  Copyright (c) 2015 Noah Marriott. All rights reserved.
//

import UIKit

class wooViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbView: UITableView!
    
    var logo = ["Logo", "Logo", "Logo", "Logo"]
    
    var name = ["California's Great America", "California's Great America", "California's Great America", "California's Great America"]
    
    var mi = ["2.2", "2.2", "2.2", "2.2"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nearby"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tbView.dequeueReusableCellWithIdentifier("cellThree") as! blahTableViewCell
        
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
