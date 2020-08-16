//
//  DisplayImages.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-12.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import CoreData

class DisplayImages: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    let persistentManager = PersistenceManager.shared
    var imageCollection: [UIImage] = []
    var sessionKey : Bool = false
    var itemAt: Int = 0
    let defaults = UserDefaults.standard
    
    func getImages(){
        print("Loading..")
        if(!sessionKey){
            let users = persistentManager.fetch(User.self)
            users.forEach({
                let image : UIImage = UIImage(data: $0.image! as Data)!
                imageCollection.append(image)
            })
        } else {
            let backupImages = persistentManager.fetch(Backup.self)
                    backupImages.forEach({
                        let image : UIImage = UIImage(data: $0.image! as Data)!
                        imageCollection.append(image)
                    })
                    print(imageCollection.count)
        }
    }
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        sessionKey = defaults.bool(forKey: Constants.USER_SESSION)
        viewLoadSetup()
        
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
            //            collectionViewFlowLayout.minimumInteritemSpacing = 5
            //
            //            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    func viewLoadSetup(){
        imageCollection = []
        getImages()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = imageCollection[indexPath.item]
        cell.sizeToFit()
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.darkGray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemAt = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imgWidth = view.bounds.width/3.0
        let imgHeight = imgWidth
        
        return CGSize(width: imgWidth, height: imgHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let dvc = segue.destination as! Detail
            dvc.modalPresentationStyle = .fullScreen
            dvc.img = imageCollection[itemAt]
            dvc.imageCollection = imageCollection
        }
    }
    
}
