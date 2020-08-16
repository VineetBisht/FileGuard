//
//  SignUp.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-08.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import CoreData
import UIKit
import KeychainSwift
import GoogleSignIn

class SignUp: ViewController, GIDSignInDelegate{
    
    let persistentManager = PersistenceManager.shared
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var justOnce: Bool = false
    let keychain = KeychainSwift()
    let defaults = UserDefaults.standard
    
    @IBAction func googleSignUp(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        password.autocorrectionType = .no
        confirmPassword.autocorrectionType = .no
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    @IBAction func signup(_ sender: Any) {
        if (email.text!.isEmpty ||
            password.text!.isEmpty ||
            confirmPassword.text!.isEmpty){
            if(!justOnce){
                errorAlert(message: "Empty Input Fields")
            }
            return
        }
        
        if(!(password.text!.elementsEqual(confirmPassword.text!))){
            if(!justOnce){
                errorAlert(message: "Passwords do not match")
            }
            return
        }
        
        if(!isValidEmail(email.text!)){
            if(!justOnce){
                errorAlert(message: "Invalid email")
            }
            return
        }
        proceedDelete(email: email.text!, password: password.text!)
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func errorAlert(message: String){
        let alert = UIAlertController(title: "Invalid", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            action in self.justOnce = false}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func proceedDelete(email: String, password: String?){
        let alert = UIAlertController(title: "Confirm", message: "Create Account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            action in self.justOnce = false
            self.deletePreviousData()
            self.keychain.set(email, forKey: Constants.ADMIN)
            if(password != nil){
                self.keychain.set(password!, forKey: Constants.PASS)
            }
            print("Saved")
            self.performSegue(withIdentifier: "Logon", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePreviousData(){
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try persistentManager.context.execute(deleteRequest)
        } catch _ as NSError {
        }
        performSegue(withIdentifier: "Home", sender: self)
        print("Erasing all data")
        
        fetchRequest = NSFetchRequest(entityName: "Backup")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try persistentManager.context.execute(deleteRequest)
        } catch _ as NSError {
        }
        performSegue(withIdentifier: "Home", sender: self)
        print("Erasing all data")
        
        keychain.delete(Constants.ADMIN)
        keychain.delete(Constants.PASS)
        defaults.removeObject(forKey: Constants.BACKUP_DEFAULT_KEY)
        defaults.removeObject(forKey: Constants.ERASEALL_DEFAULT_KEY)
        defaults.removeObject(forKey: Constants.USER_SESSION)
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
        print(user.profile.email!)
        proceedDelete(email: user.profile.email!, password: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        //
        
    }
}
