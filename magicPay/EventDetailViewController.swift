//
//  EventDetailViewController.swift
//  magicPay
//
//  Created by Lucas Farah on 8/23/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit
import MapKit
class EventDetailViewController: UIViewController {

  @IBOutlet weak var map: MKMapView!
  // set initial location in Honolulu
  let initialLocation = CLLocation(latitude: 37.397946, longitude: -121.974294)
  let regionRadius: CLLocationDistance = 1000
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
      regionRadius * 2.0, regionRadius * 2.0)
    map.setRegion(coordinateRegion, animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let title = NSUserDefaults.standardUserDefaults().stringForKey("title")
      self.title = title
      
      self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()

      centerMapOnLocation(initialLocation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
