//
//  LoginScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 12/5/2022.
//

import UIKit

class LoginScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        Task {
//            await databaseController?.signIn(email: email ?? "", password: password ?? "")
//
//            await MainActor.run {
//                performSegue(withIdentifier: "showTreesSegue", sender: sender)
//            }
//        }
        performSegue(withIdentifier: "showTreesSegue", sender: sender)
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
