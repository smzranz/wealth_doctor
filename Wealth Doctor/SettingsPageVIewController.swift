//
//  SettingsPageVIewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 01/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class SettingsPageVIewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
var tittleLabel = [String]()
    var settingImages = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleLabel = ["Language","Notification","Invite","Rate","Feedback","Terms And Conditions","Privacy","Logout"]
        
        
        settingImages = [#imageLiteral(resourceName: "language_menu"),#imageLiteral(resourceName: "notification_settings"),#imageLiteral(resourceName: "invite_settings"),#imageLiteral(resourceName: "rate_settings"),#imageLiteral(resourceName: "feedback_settings"),#imageLiteral(resourceName: "tc_menu"),#imageLiteral(resourceName: "privacy_settings"),#imageLiteral(resourceName: "logout")]
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
        case 2:
            shareApp()
        case 3 :
            rateApp(appId: "id959379869") { success in
                print("RateApp \(success)")
            }
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
    
}
