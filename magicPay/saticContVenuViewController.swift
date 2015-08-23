//
//  saticContVenuViewController.swift
//  Magicpass
//
//  Created by Noah Marriott on 8/23/15.
//  Copyright (c) 2015 Noah Marriott. All rights reserved.
//

import UIKit
import QuartzCore

class saticContVenuViewController: UIViewController {

    @IBOutlet weak var price: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        price.layer.cornerRadius = 5.0
        price.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
