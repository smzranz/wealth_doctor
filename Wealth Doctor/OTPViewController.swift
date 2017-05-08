//
//  OTPViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 02/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,UITextFieldDelegate {
    
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
   
    let gAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
    let gAppBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0"
    let limitLength = 10
var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var phoneTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(deviceID)
        print(gAppBuild)
        print(gAppVersion)

    phoneTxt.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
 
    @IBAction func otpSubmitBtn(_ sender: Any) {
        
        
        if (phoneTxt.text?.isEmpty)!
        {
            phoneTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName:UIColor.red])
           
        }
        else if validate(value: phoneTxt.text!) == false
        {
        
        displaymyalertmessage(usermessage: "Enter a valid mobile number")
        }
        else {
            
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                actstart()
                let scriptUrl = "http://www.indianmoney.com/wealthDoctor/login.php"
                
                let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
                
                let myUrl = URL(string: urlWithParams);
                
                var request = URLRequest(url:myUrl!)
             
                let postString = "mobile=\(phoneTxt.text!)&gcm_id=\(deviceID)&app_version=\(gAppVersion)"
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
                                
                                if let nestedDictionary = convertedJsonIntoArray["result"] as? [String: Any] {
                                    
                                     let otp = nestedDictionary["otp"] as! String
                                    let mobileNmbr = nestedDictionary["wda_mobile"] as! String
                                    UserDefaults.standard.set(mobileNmbr, forKey: "mobile")
                                    UserDefaults.standard.set(otp, forKey: "otp")
                                    UserDefaults.standard.synchronize()
                                    
                                   print(nestedDictionary)
                                }
                               
                                
                                
                                
                                
                                
                                DispatchQueue.main.async {
                                    self.actstop()
                                    self.performSegue(withIdentifier: "mobiletootp", sender: self)
                                                        }
                                
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
 
        
    }
    
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    func validate(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func validate(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{10}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
    }
}
