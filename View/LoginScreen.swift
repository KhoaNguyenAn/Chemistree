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
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
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
                checkNew = true
                performSegue(withIdentifier: "showTreesSegue", sender: sender)
            }
        }
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
 
