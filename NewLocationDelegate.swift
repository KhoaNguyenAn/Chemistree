//
//  NewLocationDelegate.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 13/5/2022.
//

import Foundation
protocol NewLocationDelegate: NSObject {
    func annotationAdded(annotation: LocationAnnotation)
}
