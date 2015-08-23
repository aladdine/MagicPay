//
//  MeViewController.swift
//  magicPay
//
//  Created by Lucas Farah on 8/23/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit
import MapKit
class MeViewController: UIViewController {

  @IBOutlet weak var map: MKMapView!
  
  let initialLocation = CLLocation(latitude: 37.397946, longitude: -121.974294)
  let regionRadius: CLLocationDistance = 1000
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
      regionRadius * 2.0, regionRadius * 2.0)
    map.setRegion(coordinateRegion, animated: true)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
//      
      centerMapOnLocation(initialLocation)
      var myHomePin = MKPointAnnotation()
      myHomePin.coordinate = CLLocationCoordinate2DMake(37.397946, -121.974294)

      myHomePin.title = "Home"
      myHomePin.subtitle = "Bogdan's home"
      self.map.addAnnotation(myHomePin)
      
      
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if (annotation is MKUserLocation) {
      //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
      //return nil so map draws default view for it (eg. blue dot)...
      return nil
    }
    
    let reuseId = "test"
    
    var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
    if anView == nil {
      anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      anView.image = UIImage(named:"720313864_13472305211789227906.png")
      anView.canShowCallout = true
    }
    else {
      //we are re-using a view, update its annotation reference...
      anView.annotation = annotation
    }
    
    return anView
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
