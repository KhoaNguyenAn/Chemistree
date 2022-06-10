//
//  ShowDirectionScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 6/6/2022.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ShowDirectionScreen: UIViewController {
    
    var steps: [MKRoute.Step] = []
    var stepCounter = 0
    var route: MKRoute?
    var showMapRoute = false
    var navigationStarted = false
    let locationdistance: Double = 500
    
    var speechsynthesizer = AVSpeechSynthesizer()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        directionLabel.text = " Take you to Chemistree"
        directionLabel.font = .boldSystemFont(ofSize: 20)
        directionLabel.textColor = UIColor.systemMint
        directionLabel.textAlignment = .center

        directionLabel.numberOfLines = 0
        
        getDirectionButton.setTitle("Get Direction", for: .normal)
        getDirectionButton.setTitleColor(.systemBlue, for: .normal)
        getDirectionButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        startStopButton.setTitle("Start Navigation", for: .normal)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        startStopButton.layer.cornerRadius = 15
        startStopButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            handleAuthorizationStatus(locationManager: locationManager, status: CLLocationManager.authorizationStatus())
            
        } else {
            print("Location services are not enable")
        }
        
        
        // Do any additional setup after loading the view.
        locationManager.startUpdatingLocation()
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getDirectionButtonTapped(_ sender: Any) {
        directionLabel.font = .boldSystemFont(ofSize: 16)
        directionLabel.textColor = UIColor.black
        directionLabel.textAlignment = .center
        directionLabel.numberOfLines = 4
        
        showMapRoute = true
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = destination!
        dropPin.title = "Your Tranquility"
        mapView.addAnnotation(dropPin)

        let destinationCoordinate = destination
        self.mapRoute(destinationCoordinate: destinationCoordinate!)
        
        navigationStarted.toggle()
        
        startStopButton.setTitle(navigationStarted ? "Stop Navigation" : "Start Navigation", for: .normal)
    }

    @IBAction func startStopButtonTapped(_ sender: Any) {

        if !navigationStarted {
            showMapRoute = true
            if let location = locationManager.location {
                let center = location.coordinate
                centerViewToUserLocation(center: center)
                
            }
        } else {
            if let route = route {
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), animated: true)
                self.steps.removeAll()
                self.stepCounter = 0
                
            }
        }
    }

    
    func centerViewToUserLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationdistance, longitudinalMeters: locationdistance)
        mapView.setRegion(region, animated: true)
    }
    
    func handleAuthorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //
            break
        case .denied:
            //
            break
        case .authorizedAlways:
            //
            break
        case .authorizedWhenInUse:
            if let center = locationManager.location?.coordinate {
                centerViewToUserLocation(center: center)
            }
            break
        @unknown default:
            //
            break
        }
    }
    
    func mapRoute(destinationCoordinate: CLLocationCoordinate2D) {
        guard let sourceCoordinate = locationManager.location?.coordinate else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let routeRequest = MKDirections.Request()
        routeRequest.source = sourceItem
        routeRequest.destination = destinationItem
        routeRequest.transportType = .walking
        
        let directions = MKDirections(request: routeRequest)
        directions.calculate { (response, err) in
            if let err = err {
                print(err.localizedDescription)
            return
            }
            guard let response = response, let route = response.routes.first else {
                return
            }
            
            self.route = route
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), animated: true)
            
            self.getRouteSteps(route: route)
        }
    }
    
    func getRouteSteps(route: MKRoute) {
        for monitoredRegions in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: monitoredRegions)
        }
        
        let steps = route.steps
        self.steps = steps
        
        for i in 0..<steps.count {
            let step = steps[i]
            print(step.instructions)
            print(step.distance)
            
            let region = CLCircularRegion(center: step.polyline.coordinate, radius: 20, identifier: "\(i)")
            locationManager.startMonitoring(for: region)
        }
        
        stepCounter += 1
        let initialMessage = "In \(round(steps[stepCounter].distance)) meters \(steps[stepCounter].instructions), then in \(round(steps[stepCounter + 1].distance)) meters, \(steps[stepCounter + 1].instructions)"
        directionLabel.text = initialMessage
        let speechUtterance = AVSpeechUtterance(string: initialMessage)
        speechsynthesizer.speak(speechUtterance)
    }

}

extension ShowDirectionScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
                         [CLLocation]) {
        if !showMapRoute {
            if let location = locations.last {
                let center = location.coordinate
                centerViewToUserLocation(center: center)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:
                         CLAuthorizationStatus) {
        handleAuthorizationStatus(locationManager: locationManager, status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        stepCounter += 1
        if stepCounter < steps.count {
            let message = "In \(steps[stepCounter].distance) meters \(steps[stepCounter].instructions), then in \(steps[stepCounter + 1].distance) meters, \(steps[stepCounter + 1].instructions)"
            directionLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechsynthesizer.speak(speechUtterance)
        } else {
            let message = "You have arrived at your destination"
            directionLabel.text = message
            stepCounter = 0
            navigationStarted = false
            for monitoredRegion in locationManager.monitoredRegions {
                locationManager.stopMonitoring(for: monitoredRegion)
            }
        }
    }
}

extension ShowDirectionScreen: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 9
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {            
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "destination")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "pin10")
        annotationView.isHighlighted = true
        annotationView.isEnabled = true
        return annotationView
    }
}

