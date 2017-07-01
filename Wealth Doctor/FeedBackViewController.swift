//
//  FeedBackViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir on 01/07/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController,UITextViewDelegate{
    
    let mobileNumber = UserDefaults.standard.value(forKey: "mobile")
    
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    @IBOutlet weak var emailTxt: UITextField!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var feedBackTxt: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        feedBackTxt.delegate = self
        emailTxt.layer.cornerRadius = 5
        emailTxt.layer.borderColor = UIColor.lightGray.cgColor
        emailTxt.layer.borderWidth = 1
        
        feedBackTxt.layer.cornerRadius = 5
        feedBackTxt.layer.borderColor = UIColor.lightGray.cgColor
        feedBackTxt.layer.borderWidth = 1
        
        
        sendBtnOutlet.layer.cornerRadius = 5
        sendBtnOutlet.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendBtnAction(_ sender: Any) {
        
        if (emailTxt.text?.isEmpty)! {
        
        self.emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName:UIColor.red])
            
        }
//        else if  (feedBackTxt.text.isEmpty){
//            
//        self.feedBackTxt.attributedPlaceholder = NSAttributedString(string: self.question[5], attributes: [NSForegroundColorAttributeName:UIColor.red])
//        
//        
//        }
        else if isValidEmail(testStr: emailTxt.text!) == false{
            self.emailTxt.text = ""
        self.emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName:UIColor.red])
        
        }else{
        
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                actstart()
                let scriptUrl = "https://www.indianmoney.com/wealthDoctor/feedback.php"
                
                let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
                
                let myUrl = URL(string: urlWithParams);
                
                var request = URLRequest(url:myUrl!)
                
                let postString = "email=\(emailTxt.text!)&feedback=\(feedBackTxt.text)&mobile=\(mobileNumber!)&dev_info=\(deviceID)"
                request.httpBody = postString.data(using: .utf8)
                
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if let responseString = String(data: data!, encoding: .utf8){
                        // print("responseString = \(responseString)")
                        // self.actstop()
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
                                
                                if let convertedJsonDictioanry = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                   
                                    
                                    let alert = UIAlertController(title: "Done", message: "Feedback sent Successfully", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    // add the actions (buttons)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                    
                                    
                                    
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                              
                                    
                                    
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
   
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
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
