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
    
    // MARK: - Top premissions
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
        } else {
            // TODO
            // Alert: user have to turn locations on
        }
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
            // 1. When app is running the location is authorized
        case .authorizedWhenInUse:
            // TODO
            break
            // 2. When user do not allow the app to use location
            // show alert on how to turn on permissions
            // Once is denied, user has to use general setting to allow location
        case .denied:
            break
            // 2. Ask for permissions
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // 3. Show alert that location can't be use
        case .restricted:
            break
            // When app is running in the background location is authorized
        case .authorizedAlways:
            break
        default:
            break
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

