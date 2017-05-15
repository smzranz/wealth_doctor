//
//  TipsViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 15/05/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Tips"
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //btn1.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btn1.addTarget(self, action: #selector(leftMenuPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftMenuPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MenuViewController") as! MenuViewController
        viewController.sideSelected = 4
        showAnimationLeftToRight()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    func showAnimationLeftToRight() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }

}
