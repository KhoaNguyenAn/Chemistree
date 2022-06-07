//
//  MapScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 13/5/2022.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseFirestore

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class userPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}


class MapScreen : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    let db = Firestore.firestore()
    var treeLocation:[(latitude: Double, longitude: Double, name: String)] = []
    var locations : [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    let locationdistance: Double = 900
    var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.frame.size.height = 65
        goButton.frame.size.width = 65
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        goButton.layer.masksToBounds = true
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
        treeLocation = []
        

        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            handleAuthorizationStatus(locationManager: locationManager, status: CLLocationManager.authorizationStatus())
            
        } else {
            print("Location services are not enable")
        }
        
        
        // Do any additional setup after loading the view.
        locationManager.startUpdatingLocation()
        
        retrieveData()
    }
    
    func retrieveData() {
        let docRef = db.collection("user").document(currentUserEmail!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let latitude = dataDescription!["tree_latitude"] as? [Double]
                let longitude = dataDescription!["tree_longitude"] as? [Double]
                let name = dataDescription!["tree_name"] as? [String]
                let description = dataDescription!["tree_description"] as? [String]
                if latitude!.count > 0 {
                    for i in 0..<latitude!.count {
                        self.treeLocation.append((latitude: latitude![i], longitude: longitude![i], name: name![i]))

                        //
                        let newLocation = CLLocationCoordinate2D(latitude: latitude![i], longitude: longitude![i])
                        let pin = customPin(pinTitle: name![i], pinSubTitle: description![i], location: newLocation)
                        self.mapView.addAnnotation(pin)
                    }
                }
                else {
                    return
                }
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userlocation")
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "pin6")
            annotationView.isHighlighted = true
            annotationView.isEnabled = true
            
            let annotationLabel = UILabel(frame: CGRect(x: -20, y: -35, width: 105, height: 30))
            annotationLabel.numberOfLines = 3
            annotationLabel.textAlignment = .center
            annotationLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
            annotationLabel.textColor = UIColor.systemMint
            annotationLabel.text = annotation.title!!
            annotationView.addSubview(annotationLabel)
            annotationLabel.backgroundColor = UIColor.white
            annotationLabel.layer.cornerRadius = 15
            annotationLabel.clipsToBounds = true

            // you can customize it anyway you want like any other label
            return annotationView
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "pin4")
        
        
        return annotationView
    }
    
    @objc func getDirections() {
        print("ABC")
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
                self.userLocation = center
                centerViewToUserLocation(center: center)
            }
            break
        @unknown default:
            //
            break
        }
    }
    
    func centerViewToUserLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationdistance, longitudinalMeters: locationdistance)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
                         [CLLocation]) {
        if let location = locations.last {
            let center = location.coordinate
            centerViewToUserLocation(center: center)
        }
    }
    
    // TODO: Get direction
    
    @IBAction func goToDirection(_ sender: Any) {
        performSegue(withIdentifier: "showDirectionSegue", sender: sender)
    }
    
}
