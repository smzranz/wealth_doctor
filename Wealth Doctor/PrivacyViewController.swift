//
//  PrivacyViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 21/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet var terms1: UIWebView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
         navigationItem.title = "Privacy Policy"
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            let webUrl = URLRequest(url: URL(string: "http://www.indianmoney.com/wealthDoctor/privacypolicy.php")!)
            self.terms1.loadRequest(webUrl)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
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
