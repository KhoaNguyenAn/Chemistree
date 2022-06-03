//
//  MapScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 13/5/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController, CLLocationManagerDelegate, DatabaseListener {
    
    func onUserChange(change: DatabaseChange, users: [User]) {
        // do nothing
    }
    
    func onAllTreesChange(change: DatabaseChange, trees: [Tree]) {
        currentTree = trees
        self.viewDidLoad()
    }
    
    func onAuthChange(change: DatabaseChange) {
        // do nothing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    var currentTree: [Tree] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
//        mapView.ignoresS
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
