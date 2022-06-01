//
//  Trees.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 20/5/2022.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift


class Tree: NSObject, Codable {
    @DocumentID var id: String?
    var name: String?
    var desc: String?
    var image: String?
    var lat: String?
    var log: String?
}

//enum CodeingKeys: String, CodingKey {
//    case id
//    case name
//    case desc
//    case image
//}


