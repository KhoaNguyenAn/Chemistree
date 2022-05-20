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
//    case team
//    case heroes
//    case auth
//    case all
//}
//
//protocol DatabaseListener: AnyObject {
//    var listenerType: ListenerType {get set}
//    func onUserChange(change: DatabaseChange, users: [User])
//    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero])
//    func onAuthChange(change: DatabaseChange)
//}
//
//protocol DatabaseProtocol: AnyObject {
//    func cleanup()
//
//    func addListener(listener: DatabaseListener)
//    func removeListener(listener: DatabaseListener)
//
//    func addSuperhero(name: String, abilities:String, universe: Universe) -> Superhero
//    func deleteSuperhero(hero: Superhero)
//
//    var defaultTeam: Team {get}
//    func addTeam(teamName: String) -> Team
//    func deleteTeam(team: Team)
//    func addHeroToTeam(hero: Superhero, team: Team) -> Bool
//    func removeHeroFromTeam(hero: Superhero, team: Team)
//    func logIn(email: String, password: String)
//    func signIn(email: String, password: String)
//}
