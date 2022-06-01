//
//  UIViewDisplayMessage.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 1/6/2022.
//

import UIKit
 
extension UIViewController {
    func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
}
