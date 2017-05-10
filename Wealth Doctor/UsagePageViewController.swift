//
//  UsagePageViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 25/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class UsagePageViewController: UIViewController {

    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.addTarget(self, action: #selector(swipedViewUp))
        view.addGestureRecognizer(swipeUp)
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        swipeDown.addTarget(self, action: #selector(swipedViewDown))
        view.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func swipedViewUp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"OTPViewController") as! OTPViewController
        UserDefaults.standard.setValue("welcome", forKey: "welcome")
        UserDefaults.standard.synchronize()
        self.present(viewController, animated: true)
        
    }

    func swipedViewDown(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"welcomePageViewController") as! WelcomePageViewController
        showAnimationFromTop()
        self.present(viewController, animated: false)
        
    }
    func showAnimationFromTop() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
