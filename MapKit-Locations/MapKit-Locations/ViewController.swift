//
//  ViewController.swift
//  MapKit-Locations
//
//  Created by Israel Manzo on 6/10/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/*
 1. Get permission to show location
 2. Show user location on the map
 3. Update the user location, when user moves
 */

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager(){
        
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
        } else {
            // TODO
            // Alert: user have to turn locations on
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO
    }
    
}

