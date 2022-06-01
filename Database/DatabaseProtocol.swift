//
//  DatabaseProtocol.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 20/5/2022.
//

import Foundation

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType {
    case treeList
    case user
    case auth
    case all
    case Tree
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange, users: [User])
    func onAllTreesChange(change: DatabaseChange, trees: [Tree])
    func onAuthChange(change: DatabaseChange)
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()

    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

    func addTree(name: String, desc :String, img: String) -> Tree
    func logIn(email: String, password: String) async -> Bool 
    func signIn(email: String, password: String, name: String) async -> Bool 
}
