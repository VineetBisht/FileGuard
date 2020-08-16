//
//  Detail.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-12.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import CoreData
import UIKit

class Detail: UIViewController{
    let persistentManager = PersistenceManager.shared
    var img = UIImage()
    var imageCollection: [UIImage] = []
    var sessionKey : Bool = false
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var del: UIButton!
    
    override func viewDidLoad() {
        imageView.image = img
        sessionKey = defaults.bool(forKey: Constants.USER_SESSION)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        if (touch?.view != self.imageView) && (touch?.view != self.del)
        { self.dismiss(animated: true, completion: nil) }
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        print("delete")
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        if(!sessionKey){
            fetchRequest = NSFetchRequest(entityName: "User")
        }else{
            fetchRequest = NSFetchRequest(entityName: "Backup")
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentManager.context.execute(deleteRequest)
        } catch _ as NSError {
        }
        
        for image in imageCollection{
            if(image != img){
                let imageData:NSData = image.pngData()! as NSData
                if(!sessionKey){
                    let session = User( context: persistentManager.context)
                    session.image = imageData
                }else{
                    let session = Backup( context: persistentManager.context)
                    session.image = imageData
                }
                persistentManager.saveContext()
            }else{
                print("deleted")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
