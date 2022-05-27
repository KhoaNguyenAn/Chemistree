////
////  FirebaseController.swift
////  Chemistree
////
////  Created by Khoa Nguyen on 20/5/2022.
////
//
//
//import UIKit
//import Firebase
//import FirebaseFirestoreSwift
//
//class FirebaseController: NSObject, DatabaseProtocol {
//
//
//    static var DEFAULT_TEAM_NAME = "Default Team"
//    var listeners = MulticastDelegate<DatabaseListener>()
//    var treeList: [Tree]
//    var defaultTeam: Team
//
//    var authController: Auth
//    var database: Firestore
//    var treesRef: CollectionReference?
//    var userRef: CollectionReference?
//    var currentUser: FirebaseAuth.User?
//
//
//
//    
//
//    override init() {
//        FirebaseApp.configure() //must be the first step for hadles initial configuration and setup
//        authController = Auth.auth()
//        database = Firestore.firestore()
//        treeList = [Tree]()
//
//        super.init()
//
//    }
//
//    func addListener(listener: DatabaseListener) {
//        listeners.addDelegate(listener)
//        if listener.listenerType == .trees || listener.listenerType == .all {
//            listener.onAllTreesChange(change: .update, trees: treeList) //
//        }
//
//        if listener.listenerType == .auth{
//            listener.onAuthChange(change: .update)
//        }
//    }
//
//    func removeListener(listener: DatabaseListener) {
//        listeners.removeDelegate(listener)
//    }
//
//    func addTree(name: String, desc: String, img: UIImage) -> Tree {
//        let tree = Tree()
//        tree.name = name
//        tree.desc = abilities
//        tree.img = img
//
//        do {
//            if let treesRef = try treesRef?.addDocument(from: hero) {
//                tree.id = treesRef.documentID
//            }
//        } catch {
//            print("Failed to serialize tree")
//        }
//
//        return tree
//    }
//
//    func addTeam(teamName: String) -> Team {
//        let team = Team()
//        team.name = teamName
//        if let teamRef = teamsRef?.addDocument(data: ["name" : teamName]) {
//            team.id = teamRef.documentID
//        }
//        return team
//    }
//
//    func addHeroToTeam(hero: Superhero, team: Team) -> Bool {
//        guard let heroID = hero.id, let teamID = team.id,
//              team.heroes.count < 6 else {
//                return false
//        }
//
//        if let newHeroRef = heroesRef?.document(heroID) {
//         teamsRef?.document(teamID).updateData(
//            ["heroes" : FieldValue.arrayUnion([newHeroRef])]
//         )
//        }
//        return true
//    }
//
//    func deleteSuperhero(hero: Superhero) {
//        if let heroID = hero.id{
//            heroesRef?.document(heroID).delete()
//        }
//    }
//
//    func deleteTeam(team: Team) {
//        if let teamID = team.id {
//         teamsRef?.document(teamID).delete()
//        }
//    }
//
//    func removeHeroFromTeam(hero: Superhero, team: Team) {
//        if team.heroes.contains(hero), let teamID = team.id, let heroID = hero.id {
//            if let removedHeroRef = heroesRef?.document(heroID) {
//                teamsRef?.document(teamID).updateData(
//                    ["heroes": FieldValue.arrayRemove([removedHeroRef])]
//                )
//            }
//        }
//
//    }
//
//
//
//
//    func cleanup() {
//        // nothing
//    }
//    // MARK: - Firebase Controller Specific m=Methods
//    func getHeroByID(_ id: String) -> Superhero? {
//        for hero in heroList {
//            if hero.id == id {
//                return hero
//            }
//        }
//
//        return nil
//    }
////    func setupUserListener() {
////        userRef = database.collection("users")
////
////        userRef?.addSnapshotListener() {
////
////            (querySnapshot, error) in
////            guard let querySnapshot = querySnapshot else {
////                print("Failed to fetch documents with error: \(String(describing: error))")
////                return
////            }
////            self.parseHeroesSnapshot(snapshot: querySnapshot)
////
////        }
////    }
//
//    func setupHeroListener() { // called when we have received an authentication result
//        heroesRef = database.collection("superheroes")
//
//        heroesRef?.addSnapshotListener() {
//            (querySnapshot, error) in
//
//            guard let querySnapshot = querySnapshot else {
//                print("Failed to fetch documents with error: \(String(describing: error))")
//                return
//            }
//
//            self.parseHeroesSnapshot(snapshot: querySnapshot)
//            // if it is first time the snapshot is called
//            if self.teamsRef == nil {
//                self.setupTeamListener()
//            }
//        }
//
//
//
//    }
//
//    func setupTeamListener() {
//        teamsRef = database.collection("teams")
//        teamsRef?.whereField("name", isEqualTo: FirebaseController.DEFAULT_TEAM_NAME).addSnapshotListener {
//         (querySnapshot, error) in
//            guard let querySnapshot = querySnapshot, let teamSnapshot = querySnapshot.documents.first else {
//                print("Error fetching teams: \(error!)")
//                return
//            }
//
//            self.parseTeamSnapshot(snapshot: teamSnapshot)
//        }
//    }
//
//
//    func parseHeroesSnapshot(snapshot: QuerySnapshot) {
//        snapshot.documentChanges.forEach { (change) in
//            var parsedHero: Superhero?
//
//            do {
//                parsedHero = try change.document.data(as: Superhero.self)
//            } catch {
//                print("Unable to decode hero. Is the hero malformed?")
//                return
//            }
//
//            guard let hero = parsedHero else {
//                print("Document doesn't exist")
//                return;
//            }
//
//            if change.type == .added {
//                print(change.newIndex)
//                heroList.insert(hero, at: Int(change.newIndex))
//            }else if change.type == .modified {
//                heroList[Int(change.oldIndex)] = hero
//
//            }else if change.type == .removed {
//                   heroList.remove(at: Int(change.oldIndex))
//
//            }
//
//            listeners.invoke { (listener) in
//                if listener.listenerType == ListenerType.heroes || listener.listenerType == ListenerType.all {
//                    listener.onAllHeroesChange(change: .update, heroes: heroList)
//                }
//            }
//        }
//    }
//
////    func parseUsersSnapshot(snapshot: QuerySnapshot) {
////
////
////    }
//
//    func parseTeamSnapshot(snapshot: QueryDocumentSnapshot) {
//        defaultTeam = Team()
//        defaultTeam.name = snapshot.data()["name"] as? String
//        defaultTeam.id = snapshot.documentID
//
//        if let heroReferences = snapshot.data()["heroes"] as? [DocumentReference] {
//
//            for reference in heroReferences {
//                if let hero = getHeroByID(reference.documentID) {
//                    defaultTeam.heroes.append(hero)
//                    listeners.invoke { (listener) in
//                        if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all {
//                  listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
//
//                        }
//
//                    }
//
//                }
//            }
//        }
//    }
//
//    func signIn(email: String, password: String) {
//        Task {
//            do {
//                //let authDataResult = try await authController.signInAnonymously()
//                let authDataResult = try await authController.createUser(withEmail: email, password: password)
//
//                currentUser = authDataResult.user // contain userID
//                FirebaseController.DEFAULT_TEAM_NAME = currentUser?.email ?? "Default Team"
//                database.collection("teams").document(email).setData([
//                    "name": email,
//                    "heroes": []
//
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                    }
//                }
//            }
//            catch {
//                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
//
//            }
//
//            self.setupHeroListener()
//        }
//
//
//
//    }
//
//    func logIn(email: String, password: String){
//        Task {
//            do {
//                //let authDataResult = try await authController.signInAnonymously()
//                let authDataResult = try await authController.signIn(withEmail: email, password: password)
//                //let authDataResult = try await authController.signIn(withEmail: "test@test.com", password: "test123")
//                currentUser = authDataResult.user // contain userID
//                FirebaseController.DEFAULT_TEAM_NAME = currentUser?.email ?? "Default Team"
//
//            }
//            catch {
//               fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
//
//
//            }
//            self.setupHeroListener()
//            print(currentUser?.uid ?? "none")
//            //userRef = database.collection(currentUser?.uid ?? "")
//        }
//
//
//    }
//
//
//
//}
