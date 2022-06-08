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
    var path: String?
    var img: UIImage?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D, path: String) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        self.path = path
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

var destination: CLLocationCoordinate2D?
var checkLogin: Bool = false
class MapScreen : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    let db = Firestore.firestore()
    var treeLocation:[(latitude: Double, longitude: Double, name: String)] = []
    var locations : [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    let locationdistance: Double = 900
    var userLocation: CLLocationCoordinate2D?
    var currentImg: [UIImage] = []
    var count: Int = 0
    var countPicked = 0
    var arrTag: [Int] = []
    

    
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
                let path = dataDescription!["tree_path"] as? [String]
                if latitude!.count > 0 {
                    for i in 0..<latitude!.count {
                        self.treeLocation.append((latitude: latitude![i], longitude: longitude![i], name: name![i]))
                        
                        //
                        let storageRef = Storage.storage().reference()
                        
                        // Specify the path
                        let fileRef = storageRef.child(path![i])
                        
                        // Retrieve the data
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            
                            // Check for errors
                            if error == nil && data != nil {
                                // Create a UIImage and put it into our array for display
                                if let image = UIImage(data: data!) {
                                    // *************
                                    self.currentImg.append(image)
                                    let newLocation = CLLocationCoordinate2D(latitude: latitude![i], longitude: longitude![i])
                                    let pin = customPin(pinTitle: name![i], pinSubTitle: description![i], location: newLocation, path: path![i])
                                    self.mapView.addAnnotation(pin)
                                    self.locations.append(newLocation)
                                }
                            }
                            //
                            
                        }
                    }
                } else {
                    print("Document does not exist")
                }
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
            
            return annotationView
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "pin4")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = self.currentImg[count]
        count += 1
        imageView.contentMode = .scaleAspectFit
        annotationView.leftCalloutAccessoryView = imageView
        
        // add button
        let smallSquare = CGSize(width: 75, height: 40)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: -20,y: 0), size: smallSquare))
        button.tag = count
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("Select", for: UIControl.State.normal)


        button.addTarget(self, action: #selector(getDirections(sender:)), for: UIControl.Event.touchUpInside)
        annotationView.rightCalloutAccessoryView = button
        return annotationView
    }
    
    @objc func getDirections(sender:UIButton!) {
        if sender.currentTitle == "Picked" {
            sender.backgroundColor = UIColor.systemBlue
            sender.setTitle("Select", for: UIControl.State.normal)
            countPicked -= 1
            arrTag = arrTag.filter(){$0 != sender.tag}
            return
        }
        sender.backgroundColor = UIColor.systemRed
        sender.setTitle("Picked", for: UIControl.State.normal)
        countPicked += 1
        arrTag.append(sender.tag)
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
        if countPicked == 1 {
            let firstElement = arrTag.first
            destination = locations[firstElement! - 1]
            performSegue(withIdentifier: "showDirectionSegue", sender: sender)
            return
        }
        displayMessage(title: "Can only pick one Tree to go to", message: "Please deselect some trees")
    }
    
}
