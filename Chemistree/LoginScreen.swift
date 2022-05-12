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
    

    @IBAction func loginButton(_ sender: Any) {
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
