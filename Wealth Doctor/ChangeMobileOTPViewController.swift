//
//  ChangeMobileOTPViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 29/05/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChangeMobileOTPViewController: UIViewController {
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    var oldNumber = ""
    var newNumber = ""
    var otp = ""
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var otpTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneBtn(_ sender: Any) {
        
        if (otpTxt.text?.isEmpty)!{
        
        
        }else if otpTxt.text != ""{
        
        }else{
        otpVerify()
        
        }
    }
    
    func otpVerify(){
        
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            actstart()
            let scriptUrl = "http://www.indianmoney.com/wealthDoctor/mobile_swap.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=\(oldNumber)&new_mobile=\(newNumber)&gcm_id=\(deviceID)&otp=\(otp)"
            request.httpBody = postString.data(using: .utf8)
            
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let responseString = String(data: data!, encoding: .utf8){
                    // print("responseString = \(responseString)")
                    self.actstop()
                    if error != nil
                    {
                        print("error=\(error)")
                        DispatchQueue.main.async {
                            self.actstop()
                            self.displaymyalertmessage(usermessage: "serverdown")
                        }
                        return
                    }
                    if responseString == "null\n"{
                        
                    }
                    else{
                        
                        do {
                            
                            if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                //   print(convertedJsonIntoArray)
                                
                                DispatchQueue.main.async {
                                    
                                    
                                    self.actstop()
                                    
                                }
                                
                                print(convertedJsonIntoArray)
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.actstop()
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.displaymyalertmessage(usermessage: "serverdown")
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func actstart(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func actstop(){
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }

}
