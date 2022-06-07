//
//  MapScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 13/5/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen : UIViewController {


    @IBOutlet weak var goButton: UIButton!
    



    override func viewDidLoad() {
        super.viewDidLoad()

        goButton.frame.size.height = 65
        goButton.frame.size.width = 65
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        goButton.layer.masksToBounds = true
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
    }

    // TODO: Get direction

    @IBAction func goToDirection(_ sender: Any) {
        performSegue(withIdentifier: "showDirectionSegue", sender: sender)
    }

}
