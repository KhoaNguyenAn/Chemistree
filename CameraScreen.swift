//
//  CameraScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 14/5/2022.
//

import UIKit

class CameraScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var imagePick : UIImage! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
        imageView.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
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
    
    func uploadImageToFirebase() {
        
    }

}
