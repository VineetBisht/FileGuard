//
//  Screen2.swift
//  FileGuard
//
//  Created by Vineet Singh on 2020-08-11.
//  Copyright © 2020 Vineet Singh. All rights reserved.
//

import UIKit
class Screen2: UIViewController, UIViewControllerTransitioningDelegate{
    
    @IBAction func next(_ sender: Any) {
               let transition = CATransition()
               transition.duration = 0.5
               transition.type = CATransitionType.push
               transition.subtype = .fromRight
               transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
               view.window!.layer.add(transition, forKey: kCATransition)
               performSegue(withIdentifier: "Next", sender: self)
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
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
    }
}
