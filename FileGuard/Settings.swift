//
//  Settings.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-12.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import GoogleSignIn

class Settings: UIViewController{
    @IBOutlet weak var backupSwitch: UISwitch!
    @IBOutlet weak var eraseAllLabelText: UILabel!
    @IBOutlet weak var eraseAllSwitch: UISwitch!
    @IBOutlet weak var backupLabelText: UILabel!
    @IBOutlet weak var privacyBackupLabel: UILabel!
    @IBOutlet weak var privacyEraseAllLabel: UILabel!
    var sessionKey = false
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionKey = defaults.bool(forKey: Constants.USER_SESSION)
        loadData()
    }
    
    @IBAction func AddBackupPass(_ sender: Any) {
        if(!sessionKey){
            inputPassword(key: Constants.BACKUP_DEFAULT_KEY)
        }else{
            hint(message: "Enter Username")
        }
    }
    
    @IBAction func AddEraseAllPass(_ sender: Any) {
        if(!sessionKey){
            inputPassword(key: Constants.ERASEALL_DEFAULT_KEY)
        }else{
            hint(message: "Enter hint message")
        }
    }
    
    private func loadData(){
        if(!sessionKey){
            if (defaults.object(forKey: Constants.BACKUP_DEFAULT_KEY) != nil){
                backupSwitch.setOn(true, animated: true)
                backupLabelText.text = "Change Backup Password"
            }else{
                backupSwitch.setOn(false, animated: true)
                backupLabelText.text = "Add Backup Password"
            }
            if (defaults.object(forKey: Constants.ERASEALL_DEFAULT_KEY) != nil){
                eraseAllSwitch.setOn(true, animated: true)
                eraseAllLabelText.text = "Change Erase-All Password"
            }else{
                eraseAllSwitch.setOn(false, animated: true)
                eraseAllLabelText.text = "Add Erase-All Password"
            }
        }else{
            backupLabelText.text = "Change Username"
            eraseAllLabelText.text = "Type a hint"
            privacyBackupLabel.text = "Switch on notifications"
            privacyEraseAllLabel.text = "Hints"
        }
    }
    
    func inputPassword(key: String){
        let alert = UIAlertController(title: "Enter Value", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            action in print("Added ",key,"password")
            let textField = alert.textFields![0]
            self.defaults.set(textField.text, forKey: key)
            self.loadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backupChange(_ sender: Any) {
        if(!sessionKey){
            print("here")
            if(backupSwitch.isEnabled){
                if (defaults.object(forKey: Constants.BACKUP_DEFAULT_KEY) == nil){
                    inputPassword(key: Constants.BACKUP_DEFAULT_KEY)
                }
                backupLabelText.text = "Change Backup Password"
            }else if(!backupSwitch.isEnabled){
                defaults.removeObject(forKey: Constants.BACKUP_DEFAULT_KEY)
                backupLabelText.text = "Add Backup Password"
                print("removing backup password")
            }
        }
    }
    
    
    @IBAction func eraseChange(_ sender: Any) {
        if(!sessionKey){
            if(eraseAllSwitch.isEnabled){
                if (defaults.object(forKey: Constants.ERASEALL_DEFAULT_KEY) == nil){
                    inputPassword(key: Constants.ERASEALL_DEFAULT_KEY)
                }
                eraseAllLabelText.text = "Change Erase-All Password"
            }else if(!eraseAllSwitch.isEnabled){
                defaults.removeObject(forKey: Constants.ERASEALL_DEFAULT_KEY)
                backupLabelText.text = "Add Erase-All Password"
                print("removing eraseAll password")
            }
        }else{
            hint(message: "Enter hint message")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        defaults.set(false, forKey: Constants.USER_SESSION)
        GIDSignIn.sharedInstance()?.signOut()
        performSegue(withIdentifier: "Logout", sender: self)
    }
    
    func hint(message: String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            action in
            _ = alert.textFields![0]
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
