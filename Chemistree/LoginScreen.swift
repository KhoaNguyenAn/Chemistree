//
//  LoginScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 12/5/2022.
//

import UIKit

class LoginScreen: UIViewController, DatabaseListener {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showRegisterScreenSegue", sender: sender)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        
        guard let databaseController = databaseController else {
            fatalError("no database controller")
        }
        
        Task {
            let out = await databaseController.logIn(email: email ?? "", password: password ?? "")

            if out == false {
                displayMessage(title: "Login fail", message: "")
                return
            }
            await MainActor.run {
                performSegue(withIdentifier: "showTreesSegue", sender: sender)
            }
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
 
