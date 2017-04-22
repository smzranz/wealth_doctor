//
//  Terms&ConditionsViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 21/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class Terms_ConditionsViewController: UIViewController {

    @IBOutlet var terms2: UIWebView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            let webUrl = URLRequest(url: URL(string: "http://www.indianmoney.com/wealthDoctor/terms_n_cond.php")!)
            self.terms2.loadRequest(webUrl)
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
