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

    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var goButtonRef: UIButton!
    let locationManager = CLLocationManager()
    let regionMeters: Double = 10000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinImage.layer.cornerRadius = 20
        goButtonRef.layer.cornerRadius = goButtonRef.frame.width / 2
        pinImage.clipsToBounds = true
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
            previousLocation = getCenterLocation(for: mapView)
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
    
    // Center location helper
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        guard let location = locationManager.location?.coordinate else { return }
        
        let request = createDirectionRequest(from: location)
        let directions = MKDirections(request: request)
//        resetMapView(with: directions)
        
        directions.calculate { [weak self](response, error) in
            guard let response = response else { return }
            // Adding polyline into the array of routes
            for route in response.routes {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    // MARK: - create directin request function helper
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // Reset directions
    var directionsArray:[MKDirections] = []
    
//    func resetMapView(with directions: MKDirections) {
//        guard mapView?.overlays as! MKOverlay else { return }
//        mapView.removeOverlay(overlay)
//        directionsArray.append(directions)
//        let _ = directionsArray.map { $0.cancel() }
//    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // STEP #4
    // "A"
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    // STEP #5
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
}
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // center of the map
        let center = getCenterLocation(for: mapView)
        // geocoder
        let geoCoder = CLGeocoder()
        
        guard var previousLocation = previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        previousLocation = center
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            if let error = error {
                print("Error", error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streeName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self?.addressLabel.text = "\(streetNumber) \(streeName)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 1.5
        
        return render 
    }
}

