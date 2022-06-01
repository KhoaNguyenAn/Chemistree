//
//  RegisterScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 20/5/2022.
//

import UIKit

class RegisterScreen: UIViewController, DatabaseListener {
    func onUserChange(change: DatabaseChange, users: [User]) {
        // do nothing
    }
    
    func onAllTreesChange(change: DatabaseChange, trees: [Tree]) {
        // do nothing
    }
    
    func onAuthChange(change: DatabaseChange) {
        // do nothing
    }
    
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var listenerType: ListenerType = .auth
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        let name = fullName.text
        let email = emailField.text
        let password = passwordField.text
        let passwordConfirm = confirmPasswordField.text
        if password != passwordConfirm {
            displayMessage(title: "Wrong password", message: "Please make sure you type in the same password !")
            return
        }
        
        guard let databaseController = databaseController else {
            fatalError("no database controller")
        }
        
        Task {
            let out = await databaseController.signIn(email: email ?? "", password: password ?? "", name: name ?? "")
            if out == false {
                displayMessage(title: "Register fail", message: "")
            }
            print("abc")
            
            await MainActor.run {
                performSegue(withIdentifier: "showTreesSegue", sender: sender)
            }
        }
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
