//
//  Login.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-08.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import CoreData
import KeychainSwift
import GoogleSignIn

class Login: UIViewController, GIDSignInDelegate{
    
    let keychain = KeychainSwift()
    
    let persistentManager = PersistenceManager.shared
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let defaults = UserDefaults.standard
    
    @IBAction func login(_ sender: Any) {
        
        let userK = keychain.get(Constants.ADMIN)!
        
        if(email.text!.isEmpty || password.text!.isEmpty){
            errorAlert(message: "Empty fields")
            return
        }
        
        let backupKey = defaults.object(forKey: Constants.BACKUP_DEFAULT_KEY)
        let eraseKey = defaults.object(forKey: Constants.ERASEALL_DEFAULT_KEY)
        
        if(email.text!.elementsEqual(userK)){
            if(backupKey != nil && password.text!.elementsEqual(backupKey as! String)){
                defaults.set(true, forKey: Constants.USER_SESSION)
                performSegue(withIdentifier: "Home", sender: self)
                print("backup")
                return
            }
            else if(eraseKey != nil && password.text!.elementsEqual(eraseKey as! String)){
                var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
                var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do{
                    try persistentManager.context.execute(deleteRequest)
                } catch _ as NSError {
                }
                
                fetchRequest = NSFetchRequest(entityName: "Backup")
                deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do{
                    try persistentManager.context.execute(deleteRequest)
                } catch _ as NSError {
                }
                
                
                defaults.removeObject(forKey: Constants.BACKUP_DEFAULT_KEY)
                defaults.removeObject(forKey: Constants.ERASEALL_DEFAULT_KEY)
                defaults.removeObject(forKey: Constants.USER_SESSION)
                
                
                performSegue(withIdentifier: "Home", sender: self)
                print("Erasing all data")
                return
            }
            
            let passK = keychain.get(Constants.PASS)!
            
            if(password.text!.elementsEqual(passK)){
                defaults.set(false, forKey: Constants.USER_SESSION)
                performSegue(withIdentifier: "Home", sender: self)
                print("normal")
            }else{
                errorAlert(message: "Invalid Credentials")
            }
        }else{
            errorAlert(message: "Email not registered")
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func errorAlert(message: String){
        let alert = UIAlertController(title: "Invalid", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userK = keychain.get(Constants.ADMIN)!
        
        if((user.profile.email)!.elementsEqual(userK)){
            segueHome()
        }else{
            print(user.profile.email!," ",userK)
            errorAlert(message: "Wrong Email ")
            GIDSignIn.sharedInstance()?.signOut()
        }
    }
    
    func segueHome(){
        DispatchQueue.main.async {
            self.getTopMostViewController()?.performSegue(withIdentifier: "Home", sender: nil)
        }
        print("signed in with google")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        //
        
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        print(topMostViewController)
        return topMostViewController
    }
}
