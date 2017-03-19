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
}
