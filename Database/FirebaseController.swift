//
//  FirebaseController.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 20/5/2022.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    
    static var DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var treeList: [Tree]
    
    var authController: Auth
    var database: Firestore
    var treesRef: CollectionReference?
    var userRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    
    
    
    
    override init() {
        FirebaseApp.configure() //must be the first step for hadles initial configuration and setup
        authController = Auth.auth()
        database = Firestore.firestore()
        treeList = [Tree]()
        
        super.init()
        
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .treeList || listener.listenerType == .all {
            listener.onAllTreesChange(change: .update, trees: treeList) //
        }
        
        if listener.listenerType == .auth{
            listener.onAuthChange(change: .update)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addTree(name: String, desc: String, img: String) -> Tree {
        let tree = Tree()
        tree.name = name
        tree.desc = desc
        tree.image = img
        
        do {
            if let treesRef = try treesRef?.addDocument(from: tree) {
                tree.id = treesRef.documentID
            }
        } catch {
            print("Failed to serialize tree")
        }
        
        return tree
    }
    
    func cleanup() {
        // nothing
    }
    // MARK: - Firebase Controller Specific m=Methods
    func getTreeByID(_ id: String) -> Tree? {
        for tree in treeList {
            if tree.id == id {
                return tree
            }
        }
        
        return nil
    }
    
    func setupUserListener() {
        userRef = database.collection("users")
        
        userRef?.addSnapshotListener() {
            
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseTreesSnapshot(snapshot: querySnapshot)
            
        }
    }
    
    func setupTreeListener() { // called when we have received an authentication result
        treesRef = database.collection("trees")
        
        treesRef?.addSnapshotListener() {
            (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            
            self.parseTreesSnapshot(snapshot: querySnapshot)
        }
    }
    
    
    func parseTreesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parsedTree: Tree?
            
            do {
                parsedTree = try change.document.data(as: Tree.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let tree = parsedTree else {
                print("Document doesn't exist")
                return;
            }
            
            if change.type == .added {
                print(change.newIndex)
                treeList.insert(tree, at: Int(change.newIndex))
            }else if change.type == .modified {
                treeList[Int(change.oldIndex)] = tree
                
            }else if change.type == .removed {
                treeList.remove(at: Int(change.oldIndex))
                
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.treeList || listener.listenerType == ListenerType.all {
                    listener.onAllTreesChange(change: .update, trees: treeList)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, name: String) async -> Bool {
        do {
            //let authDataResult = try await authController.signInAnonymously()
            let authDataResult = try await authController.createUser(withEmail: email, password: password)
            currentUser = authDataResult.user // contain userID
            print(currentUser)
//            FirebaseController.DEFAULT_TEAM_NAME = currentUser?.email ?? "Default Team"
            database.collection("user").document(email).setData([
                "name": name,
                "email": email
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            await MainActor.run {
                self.setupTreeListener()
            }
            
            return true
            
        }
        catch {
            return false
            //fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            
        }

    }
    
    func logIn(email: String, password: String) async -> Bool {
        print("abc")
        do {
            //let authDataResult = try await authController.signInAnonymously()
            let authDataResult = try await authController.signIn(withEmail: email, password: password)
            //let authDataResult = try await authController.signIn(withEmail: "test@test.com", password: "test123")
            currentUser = authDataResult.user // contain userID
//            FirebaseController.DEFAULT_TEAM_NAME = currentUser?.email ?? "Default Team"
            await MainActor.run {
                self.setupTreeListener()
                print(currentUser?.uid ?? "none")
            }
            return true
        }
        catch {
            print("Firebase Authentication Failed with Error \(String(describing: error))")
            return false
            // fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
        }
        //userRef = database.collection(currentUser?.uid ?? "")
    }
}
