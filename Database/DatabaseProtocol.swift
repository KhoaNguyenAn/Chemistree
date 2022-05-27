////
////  DatabaseProtocol.swift
////  Chemistree
////
////  Created by Khoa Nguyen on 20/5/2022.
////
//
//import Foundation
//
//enum DatabaseChange{
//    case add
//    case remove
//    case update
//}
//
//enum ListenerType {
//    case allTrees
//    case user
//    case auth
//    case all
//    case tree
//}
//
//protocol DatabaseListener: AnyObject {
//    var listenerType: ListenerType {get set}
//    func onUserChange(change: DatabaseChange, users: [User])
//    func onAllTreesChange(change: DatabaseChange, trees: [Tree])
//    func onAuthChange(change: DatabaseChange)
//}
//
//protocol DatabaseProtocol: AnyObject {
//    func cleanup()
//
//    func addListener(listener: DatabaseListener)
//    func removeListener(listener: DatabaseListener)
//
//    func addTree(name: String, desc :String, img: UIImage) -> Tree
//    func logIn(email: String, password: String)
//    func signIn(email: String, password: String)
//}
