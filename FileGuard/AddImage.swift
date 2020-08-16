//
//  AddImage.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-11.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import CoreData
class AddImage: UIViewController{
    
    let persistenceManager = PersistenceManager.shared
    let defaults = UserDefaults.standard
    var sessionKey : Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    var img = UIImage()
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = img
        sessionKey = defaults.bool(forKey: Constants.USER_SESSION)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let imageData:NSData = img.pngData()! as NSData
        
        if(!sessionKey){
        let user = User( context: persistenceManager.context)
        user.image = imageData
        persistenceManager.saveContext()
        print("saved")
        dismiss(animated: true, completion: nil)
        }
        else{
            let user = Backup( context: persistenceManager.context)
            user.image = imageData
            persistenceManager.saveContext()
            print("saved backup")
            dismiss(animated: true, completion: nil)
        }
    }
}
