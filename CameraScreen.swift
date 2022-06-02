//
//  CameraScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 14/5/2022.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseFirestore
import CoreLocation

class CameraScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                    DatabaseListener, CLLocationManagerDelegate {
    
    func onUserChange(change: DatabaseChange, users: [User]) {
        // do nothing
    }
    
    func onAllTreesChange(change: DatabaseChange, trees: [Tree]) {
        // do nothing
    }
    
    func onAuthChange(change: DatabaseChange) {
        // do nothing
    }
    
    var listenerType: ListenerType = .auth
    weak var databaseController: DatabaseProtocol?
    var locationManager = CLLocationManager()
    var longitude : Double?
    var latitude : Double?
    
    @IBOutlet weak var treeName: UITextField!
    
    @IBOutlet weak var treeDescription: UITextField!
    var imagePick : UIImage! = nil
    var check : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        check = false
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        // Do any additional setup after loading the view.

//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
        imageView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func uploadPic(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    @IBAction func takePic(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @IBAction func uploadYourTree(_ sender: Any) {
        uploadImageToFirebase()
        navigationController?.popViewController(animated: false)
        return
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imagePick = image
        imageView.image = image
        
    }
    
    @IBAction func takeLocation(_ sender: Any) {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
//        guard let locationValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
//        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if check == false {
            guard let locationValue: CLLocationCoordinate2D = locationManager.location?.coordinate
                    else { return }
//            print("locations = \(locationValue.latitude) \(locationValue.longitude)")
            self.latitude = locationValue.latitude
            self.longitude = locationValue.longitude
            check = true
        }
        return
    }

    
    func uploadImageToFirebase() {
        // Make sure that the selected image isn't nil
        guard imagePick != nil else {
            displayMessage(title: "Missing tree image", message: "Please upload tree image")
            return
        }
        
        guard treeName != nil else {
            displayMessage(title: "Missing tree name", message: "Please upload tree name")
            return
        }
        
        if check == false {
            displayMessage(title: "Missing tree location", message: "Please take your tree location")
            return
        }
        
        // Create storage reference
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // Turn our image into data
        let imageData = imagePick!.jpegData(compressionQuality: 0.8)
        
        // Check that we were able to convert it to data
        guard imageData != nil else {
            return
        }
        
        // Specify the file path and name
        let path = "trees_images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            
            // Check for errors
            if error == nil && metadata != nil {
                
                //TODO: Save a reference to the file in Firestore DB
                

                guard let databaseController = self.databaseController else {
                    fatalError("no database controller")
                }
                
                databaseController.addTree(
                    name: self.treeName.text!,
                    desc: self.treeDescription.text!,
                    img: path,
                    lat: self.latitude!,
                    log: self.longitude!
                )

//                let db = Firestore.firestore()
//                db.collection("trees").document().setData(
//                    ["name": self.treeName.text!,
//                     "desc": self.treeDescription.text!,
//                     "url_img": path]
//                )
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        check = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        check = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext

    }
}
