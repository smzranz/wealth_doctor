//
//  SettingsPageVIewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 01/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit
import MessageUI

class SettingsPageVIewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
var tittleLabel = [String]()
     var window: UIWindow?
    var settingImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "home_close_menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //btn1.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btn1.addTarget(self, action: #selector(leftMenuPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButton(item1, animated: true)
        
        
        
        let rightBarButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: nil)
        //UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.myRightSideBarButtonItemTapped(_:)))
        rightBarButton.tintColor = ColorFile().getMarkerDarkAshColor()
        self.navigationItem.leftBarButtonItem = rightBarButton
        
//        let btn = UIButton(type: .custom)
//        btn.setTitle("Settings", for: .normal)
//        btn.frame = CGRect(x: -15, y: 0, width: 150, height: 30)
//         btn.setTitleColor(ColorFile().getMarkerDarkAshColor(), for: .normal)
//        btn.titleLabel?.textAlignment = .right
//      //  btn.titleLabel?.text = "Settings"
//        let item = UIBarButtonItem(customView: btn)
//        self.navigationItem.setLeftBarButton(item, animated: true)
        
        tittleLabel = ["Language","Notification","Change Mobile Number","Invite","Rate","Feedback","Terms And Conditions","Privacy"]
        navigationController?.hidesBarsOnSwipe = false

        
        settingImages = [#imageLiteral(resourceName: "language_menu"),#imageLiteral(resourceName: "notification_settings"),#imageLiteral(resourceName: "chat_menu_copy"),#imageLiteral(resourceName: "invite_settings"),#imageLiteral(resourceName: "rate_settings"),#imageLiteral(resourceName: "feedback_settings"),#imageLiteral(resourceName: "tc_menu"),#imageLiteral(resourceName: "privacy_settings")]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tittleLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingPageCell
        settingsCell.languageLabel.isHidden = true
        settingsCell.settingsSwich.isHidden = true

        
        if indexPath.row == 0{
        settingsCell.languageLabel.isHidden = false
            
        
        }
        else if indexPath.row == 1{
        
        settingsCell.settingsSwich.isHidden = false
        
        }
        
        settingsCell.settingsLabel.text = tittleLabel[indexPath.row]
        settingsCell.settingsIcon.image = settingImages[indexPath.row]
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2 :
            performSegue(withIdentifier: "toChangeNumber", sender: self)
        case 3:
            shareApp()
        case 4 :
            rateApp(appId: "id1232131220") { success in
                print("RateApp \(success)")
            }
        case 5 :
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.window?.rootViewController?.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            

        case 6 :
            performSegue(withIdentifier: "toTerms", sender: self)
        case 7 :
              performSegue(withIdentifier: "toPrivacy", sender: self)
        default:
            break
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        //        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
        //            completion(false)
        //            return
        //        }
        guard let url = URL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software") else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    func shareApp(){
        
        let message = "About App"
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList,UIActivityType.mail,UIActivityType.message,UIActivityType.postToFacebook,UIActivityType.postToTwitter]
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        let myalert = UIAlertController(title: "Alert!", message: "Are you sure want to sign out", preferredStyle: UIAlertControllerStyle.alert )
        
        let noaction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
//            let appDomain = Bundle.main.bundleIdentifier!
//            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            
            UserDefaults.standard.removeObject(forKey: "mobile")
            UserDefaults.standard.removeObject(forKey: "mobileverified")
            UserDefaults.standard.removeObject(forKey: "otp")
//            UserDefaults.standard.set(nil, forKey: "mobile")
//             UserDefaults.standard.set(nil, forKey: "mobileverified")
//            UserDefaults.standard.set(nil, forKey: "otp")
            
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "toNumber", sender: self)
        }
        myalert.addAction(noaction)
        myalert.addAction(yesAction)
        self.present(myalert, animated: true, completion: nil)
        
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["someone@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("Sending e-mail !", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func leftMenuPressed() {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.pushViewController(viewController, animated: false)
    }


}
