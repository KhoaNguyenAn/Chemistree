//
//  LoginScreen.swift
//  Chemistree
//
//  Created by Khoa Nguyen on 12/5/2022.
//

import UIKit
import CoreData
class LoginScreen: UIViewController, DatabaseListener {
    func onUserChange(change: DatabaseChange, users: [User]) {
        // do nothing
    }
    
    func onAllTreesChange(change: DatabaseChange, trees: [Tree]) {
        // do nothing
    }
    
    func onAuthChange(change: DatabaseChange) {
        // do nothing
    }
    
    
    var listenerType: ListenerType = .auth
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 197/255, green: 214/255, blue: 217/255, alpha: 1.0)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showRegisterScreenSegue", sender: sender)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        
        guard let databaseController = databaseController else {
            fatalError("no database controller")
        }
        
        Task {
            let out = await databaseController.logIn(email: email ?? "", password: password ?? "")

            if out == false {
                displayMessage(title: "Login fail", message: "")
                return
            }
            await MainActor.run {
                currentUserEmail = email
                checkNew = true
                checkLogin = true
                performSegue(withIdentifier: "showTreesSegue", sender: sender)
            }
        }
    }
    
    @IBAction func saveUser(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        createUser(email: email ?? "", password: password ?? "")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Sign Out"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var users = [NSManagedObject]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func getD(_ sender: Any) {
        getData()
    }
    func getData() {
        do {
//            var allTeamsFetchedResultsController: NSFetchedResultsController<User>?
//            let request: NSFetchRequest<User> = User.fetchRequest()
//            allTeamsFetchedResultsController = NSFetchedResultsController<User>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            try allTeamsFetchedResultsController?.performFetch()
//            if let users = allTeamsFetchedResultsController?.fetchedObjects {
//                emailField.text = users.last?.value(forKey: "email") as? String
//                passwordField.text = users.last?.value(forKey: "password") as? String
//            }
            
            users = try context.fetch(User.fetchRequest())
            print(users)
            if users.count > 0 {
//                print(users[0])
                if let unwrapped = users.last?.value(forKey: "email") {
                    print(unwrapped)
                    emailField.text = unwrapped as! String
                }
                if let unwrapped = users.last?.value(forKey: "password") {
                    print(unwrapped)
                    passwordField.text = unwrapped as! String
                }

            }
        }
        catch {
            // error
            return
        }
    }
    
    func createUser(email: String, password: String) {
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password
        
        do {
            try context.save()
        }
        catch {
            return
        }
        
    }

}
 
