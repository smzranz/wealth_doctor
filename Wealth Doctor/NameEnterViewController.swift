//
//  NameEnterViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 24/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class NameEnterViewController: UIViewController {
    
    @IBOutlet var nextBtnOutlet: UIButton!
    @IBOutlet var nameTxt: UITextField!
     let mobileNumber = UserDefaults.standard.value(forKey: "mobile")
    var mr : Int = 1
    @IBOutlet var mrOultet: UIButton!
     @IBOutlet var mrsOultet: UIButton!
     @IBOutlet var msOultet: UIButton!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtnOutlet.layer.cornerRadius = 8
        nextBtnOutlet.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func mrsBtn(_ sender: Any) {
        mr = 2
        mrOultet.isSelected = false
        mrsOultet.isSelected = true
        msOultet.isSelected = false
        mrOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
        mrsOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox Filled-50"), for: .selected)
        msOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
        
    }
    
    
    @IBAction func msBtn(_ sender: Any) {
        mr = 3
        mrOultet.isSelected = false
        mrsOultet.isSelected = false
        msOultet.isSelected = true
        mrOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
        mrsOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
        msOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox Filled-50"), for: .selected)
    }
    
    @IBAction func mrBtn(_ sender: Any) {
        mr = 1
        mrOultet.isSelected = true
        mrsOultet.isSelected = false
        msOultet.isSelected = false
        mrOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox Filled-50"), for: .selected)
        mrsOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
        msOultet.setImage(#imageLiteral(resourceName: "Checked Checkbox-50 (1)"), for: .normal)
    }

    @IBAction func nextBtn(_ sender: Any) {
        
        
        if (nameTxt.text?.isEmpty)!{
        
            nameTxt.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName:UIColor.red])
            
        }
        else {
            
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                UserDefaults.standard.set(nameTxt.text!, forKey: "Name")
                UserDefaults.standard.set(mr, forKey: "Mr")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "nameToState", sender: self)
                
        }
        
        
        
    }
    
    
    }
    
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }
    
        
    
    
    
    
}
