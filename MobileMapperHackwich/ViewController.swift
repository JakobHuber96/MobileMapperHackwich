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
        let span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var currentMapItem = MKMapItem()
        let coordinate = annotation.coordinate
        for mapitem in parks {
            if mapitem.placemark.coordinate.latitude == coordinate.latitude &&

                mapitem.placemark.coordinate.longitude == coordinate.longitude {

                currentMapItem = mapitem
            }
        }
        

        let placemark = currentMapItem.placemark
        print(currentMapItem)
        if let parkName = placemark.name, let streetNumber = placemark.subThoroughfare, let streetName =
            placemark.thoroughfare
        {

            let streetAddress = streetNumber + " " + streetName

            let alert = UIAlertController(title: parkName, message: streetAddress, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        var pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if let title = annotation.title, let actualTitle = title {
            if actualTitle == "Twin Silo Park" { //This name depends on where you set simulator location
                pin.image = UIImage(named: "PinMage")
            } else {
                let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                marker.markerTintColor = .blue
                pin = marker
            }
        }
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
       
        if annotation.isEqual(mapView.userLocation) {
            return nil
       
        }
        return pin
    }
    
    
    
    
    
}

