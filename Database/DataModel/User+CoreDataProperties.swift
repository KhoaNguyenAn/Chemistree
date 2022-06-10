//
//  User+CoreDataProperties.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 10/6/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
