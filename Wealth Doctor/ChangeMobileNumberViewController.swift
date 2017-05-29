//
//  ChangeMobileNumberViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 22/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChangeMobileNumberViewController: UIViewController {
 let deviceID = UIDevice.current.identifierForVendor!.uuidString
    @IBOutlet var doneOutlet: UIButton!
    @IBOutlet var newMobileNumber: UITextField!
    @IBOutlet var oldMobileTxt: UITextField!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
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
        if (oldMobileTxt.text?.isEmpty)! || (newMobileNumber.text?.isEmpty)!{
        displaymyalertmessage(usermessage: "All fields are required")
        
        
        }
        else if validate(value: oldMobileTxt.text!) == false || validate(value: newMobileNumber.text!) == false{
        
        displaymyalertmessage(usermessage: "Enter a valid mobile number")
        }
        else{
        changeMobileNumber()
            
            
        }
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }
    
    func changeMobileNumber(){
    
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
            
            let postString = "mobile=\(oldMobileTxt.text!)&new_mobile=\(newMobileNumber.text!)&gcm_id=\(deviceID)"
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
                                print(convertedJsonIntoArray)

                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier :"changeMobileOTPViewController") as! ChangeMobileOTPViewController
                                    viewController.oldNumber = self.oldMobileTxt.text!
                                    viewController.newNumber = self.newMobileNumber.text!
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                    
                                    self.actstop()
                                    
                                }
                                    
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

}

