//
//  ChangeMobileNumberViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 22/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChangeMobileNumberViewController: UIViewController {

    @IBOutlet var doneOutlet: UIButton!
    @IBOutlet var newMobileNumber: UITextField!
    @IBOutlet var oldMobileTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        doneOutlet.layer.cornerRadius = 8
        doneOutlet.layer.masksToBounds = true
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneBtn(_ sender: Any) {
    }
  
}
