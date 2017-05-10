//
//  WelcomePageViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 25/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
let swipeUp = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.addTarget(self, action: #selector(WelcomePageViewController.swipedViewUp))
        view.addGestureRecognizer(swipeUp)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func swipedViewUp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"usagePageViewController") as! UsagePageViewController
       
        self.present(viewController, animated: true)
        
    }
}
