//
//  Screen1.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-11.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import KeychainSwift

class Screen1: UIViewController{
    let keychain = KeychainSwift()
    
    @IBAction func next(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        performSegue(withIdentifier: "Next", sender: self)
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        keychain.delete(Constants.TUTORIAL_COMPLETE)
        
        if let val=keychain.getBool(Constants.TUTORIAL_COMPLETE), val == true {
            performSegue(withIdentifier: "Login", sender: self)
        }
    }
}
