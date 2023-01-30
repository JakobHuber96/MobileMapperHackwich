//
//  ViewController.swift
//  MobileMapperHackwich
//
//  Created by Huber, Jakob - Student on 1/30/23.
//

import UIKit
import MapKit





class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
var currentLocation: CLLocation!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }
    var parks: [MKMapItem] = []
    
    @IBAction func whenZoomButtonPressed(_ sender: Any) {
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: coordinateSpan)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func whenSearchButtonPressed(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
        guard let response = response else { return }
        for mapItem in response.mapItems {
        self.parks.append(mapItem)
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        self.mapView.addAnnotation(annotation)
        }
        }
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
    currentLocation = locations[0]
    }
    
    
    
    
    
    
    
}

