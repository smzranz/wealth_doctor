//
//  KnowMoreViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 12/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class KnowMoreViewController: UIViewController {
var urlstring = ""
    
    
    @IBOutlet var terms1: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlstring)
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            let webUrl = URLRequest(url: URL(string: "\(urlstring)")!)
            self.terms1.loadRequest(webUrl)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }
}
