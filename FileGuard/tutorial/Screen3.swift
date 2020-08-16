//
//  Screen3.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-11.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
import KeychainSwift

class Screen3: UIViewController{
    let keychain=KeychainSwift()
    override func viewDidLoad() {
        super .viewDidLoad()
    }
    
    @IBAction func previous(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        performSegue(withIdentifier: "Previous", sender: self)
    }
    
    @IBAction func start(_ sender: Any) {
        keychain.set(true, forKey: Constants.TUTORIAL_COMPLETE)
            performSegue(withIdentifier: "Start", sender: self)
    }
}
