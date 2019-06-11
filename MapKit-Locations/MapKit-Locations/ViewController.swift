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
    let regionMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    // ===================== MARK: - Top premissions ======================
    // ====================================================================
    // STEP #2
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // STEP #1
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuth()
        } else {
            // TODO
            // Alert: user have to turn locations on
        }
    }
    
    // STEP #3
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
            // 1. When app is running the location is authorized
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewInUserLocation()
            // This line calls the delegate method "A"
            locationManager.startUpdatingLocation()
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
    // ====================================================================
    // ====================================================================

    // MARK: - Set Region user location and zoom the map on location
    func centerViewInUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // STEP #4
    // "A"
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
    }
    
    // STEP #5
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
}

