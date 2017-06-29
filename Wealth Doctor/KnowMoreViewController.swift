//
//  KnowMoreViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 12/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class KnowMoreViewController: UIViewController,UIWebViewDelegate {
var urlstring = ""
    
    
    @IBOutlet var terms1: UIWebView!
    var myActivityIndicator: UIActivityIndicatorView!
    var colorObject = ColorFile()
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
        myActivityIndicator.startAnimating()
        
        
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        myActivityIndicator.stopAnimating()
        
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //  myActivityIndicator.center = webView.center
        
        myActivityIndicator.frame = CGRect(x: Double(self.view.frame.width/2)-Double(myActivityIndicator.frame.width/2), y: Double(self.view.frame.height/2)-Double(myActivityIndicator.frame.height/2)-44, width: Double(myActivityIndicator.frame.width), height: Double(myActivityIndicator.frame.height))
        myActivityIndicator.startAnimating()
        myActivityIndicator.color = colorObject.getPrimaryColor()
        terms1.addSubview(myActivityIndicator)
          navigationController?.hidesBarsOnSwipe = false
        navigationController?.isNavigationBarHidden = false
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
