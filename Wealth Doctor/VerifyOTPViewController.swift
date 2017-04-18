//
//  VerifyOTPViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 04/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit


class State {
    var stateId: String?
    var stateName: String?
//    var stateCities: Array<Any>

     init(dictionay: Dictionary<String, Any>) {
        stateId =  dictionay["s_id"] as! String?
        stateName =  dictionay["s_name"] as! String?
        
        
        
    }
    
}

class VerifyOTPViewController: UIViewController {
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var otpTxt: UITextField!
    
    let otpNumber = UserDefaults.standard.value(forKey: "otp")
    let mobileNumber = UserDefaults.standard.value(forKey: "mobile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
 self.navigationController?.isNavigationBarHidden = true
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    
    @IBAction func otpVerifyBtn(_ sender: Any) {
        
        if (otpTxt.text?.isEmpty)!
        {
            otpTxt.attributedPlaceholder = NSAttributedString(string: "enter OTP", attributes: [NSForegroundColorAttributeName:UIColor.red])
            
        }
            
        else if otpTxt.text != otpNumber as? String{
        
        print("otp desnot match")
        
        }
        else {
            
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                
                let scriptUrl = "http://www.indianmoney.com/wealthDoctor/ios/verifyLoginOtp.php"
                
                let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
                
                let myUrl = URL(string: urlWithParams);
                
                var request = URLRequest(url:myUrl!)
                
                let postString = "otp=\(otpTxt.text!)&gcm_id=\(deviceID)&mobile=\(mobileNumber!)"
                request.httpBody = postString.data(using: .utf8)
                
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    let responseString = String(data: data!, encoding: .utf8)
                    // print("responseString = \(responseString)")
                    self.actstop()
                    if error != nil
                    {
                        print("error=\(error)")
                        DispatchQueue.main.async {
                            self.displaymyalertmessage(usermessage: "serverdown")
                        }
                        return
                    }
                    if responseString == "null\n"{
                        
                    }
                    else{
                        
                        do {
                            
                            if let convertedJsonDictioanry = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                // print(convertedJsonDictioanry)
                                
                                if let states = convertedJsonDictioanry["state"] as? NSArray {
                                
                                  //  var statesArray: Array<State>?
                                for i in 0..<states.count {
                                    
                                    if let stateData = states[i] as? NSDictionary {
//                                        
//                                        let aState: State = State(dictionay: stateData as! Dictionary<String, Any>)
                                        //                                        "sl.no"
                                      
//                                        statesArray?.append(aState)
                                    
                                        if let city = stateData["city"] as? NSArray{
                                        let state_id = stateData["s_id"] as! String
                                            let state_name = stateData["s_name"] as! String
                                            for i in 0..<city.count{
                                                if let cities = city[i] as? NSDictionary{
                                                
                                                let city_id = cities["c_id"] as! String
                                                    let city_name = cities["c_name"] as! String
                                                  //  print(city_id)
                                                  //  print(city_name)
                                                    
                                            DataBaseManager.shared.ExecuteCommand(query: "insert into STATES (stateID, stateNAME) values ( '\(state_id)', '\(state_name)');")
                                                    
                                            DataBaseManager.shared.ExecuteCommand(query: "insert into CITIES (stateID, cityID,cityNAME) values ( '\(state_name)', '\(city_id)','\(city_name)');")
                                                }
                                            
                                            }
                                        
                                        }
                                  //  print(stateData["s_id"] ?? "")
                                   // print(stateData["s_name"] ?? "")
                                    }
                                    }
                                    
                                 //   print(states)
                                }
                                
                                
                                    
                            
//                                let nestedDictionary: Dictionary = Dictionary(convertedJsonIntoArray[0])
                                //{
                                    
//                                    let otp = nestedDictionary["s_id"] as String
                                

                                    
//                                    print(otp)
//                                }
                                
                                
                                
                                
                                
                                
                                DispatchQueue.main.async {
                                    
                                    self.performSegue(withIdentifier: "verifyToState", sender: self)
                                }
                                
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            
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
    
    
}
