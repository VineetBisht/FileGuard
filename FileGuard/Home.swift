//
//  Home.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-11.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import CoreData
import UIKit
import KeychainSwift

class Home: UIViewController{
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var addNewClick: UIButton!
    var img = UIImage()
    var justOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        definesPresentationContext = true
    }
    
    @IBAction func addFromPhotos(_ sender: Any) {
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            addPhoto.isEnabled = false
            addNewClick.isEnabled = false
        }else{
            errorAlert(message: "Gallery Not Accessible.")
        }
    }
    
    @IBAction func addFromCamera(_ sender: Any) {
        if UIImagePickerController.availableMediaTypes(for: .camera) != nil {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
            addPhoto.isEnabled = false
            addNewClick.isEnabled = false
        }else{
            errorAlert(message: "Camera Not Accessible.")
        }
    }
}

extension Home: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image =  info[.editedImage] as? UIImage {
            img = image
            addPhoto.isEnabled = true
            addNewClick.isEnabled = true
            
        }
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "PresentImage", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentImage" {
            let dvc = segue.destination as! AddImage
            dvc.img = img
        }
    }
    
    func errorAlert(message: String){
        let alert = UIAlertController(title: "Invalid", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            action in self.justOnce = false}))
        self.present(alert, animated: true, completion: nil)
    }
}
