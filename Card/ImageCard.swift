//
//  ImageCard.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 12/5/2022.
//

import UIKit

class ImageCard: CardView {
    var name: String?
    var des: String?
    var lat: Double?
    var log: Double?
    var path: String?
    init(frame: CGRect, img: UIImage, name: String, description: String, lat: Double, log: Double, path: String ) {
        super.init(frame: frame)
        self.name = name
        self.des = description
        self.lat = lat
        self.log = log
        self.path = path
        // image
        
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 67/255, green: 79/255, blue: 182/255, alpha: 1.0)
//        imageView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
        self.addSubview(imageView)
        
        // dummy text boxes
        
//        let textBox1 = UIView()
//        textBox1.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        textBox1.layer.cornerRadius = 12
//        textBox1.layer.masksToBounds = true
//
//        textBox1.frame = CGRect(x: 12, y: imageView.frame.maxY + 15, width: 200, height: 24)
        
        //
        let textBox1 = UILabel()
        textBox1.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        textBox1.textColor = UIColor.black
        textBox1.layer.cornerRadius = 12
        textBox1.layer.masksToBounds = true
        textBox1.frame = CGRect(x: 12, y: imageView.frame.maxY + 15, width: 120, height: 24)
        textBox1.text = name
        //
        self.addSubview(textBox1)

        let textBox2 = UILabel()
        textBox2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        textBox2.textColor = UIColor.black
        textBox2.layer.cornerRadius = 12
        textBox2.layer.masksToBounds = true
        textBox2.frame = CGRect(x: 12, y: textBox1.frame.maxY + 10, width: 200, height: 30)
        textBox2.text = description
        self.addSubview(textBox2)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
