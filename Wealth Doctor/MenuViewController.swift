//
//  MenuViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 19/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate {
    
    var sectionItems2 : [String]!
    var sectionItems1 : [String]!
    var menuImagesArray : [UIImage]!
    var menuNameArray : [String]!
    override func viewDidLoad() {
        super.viewDidLoad()

       menuImagesArray = [#imageLiteral(resourceName: "me_menu"),#imageLiteral(resourceName: "feeds_menu"),#imageLiteral(resourceName: "unread_menu"),#imageLiteral(resourceName: "bookmarks_menu"),#imageLiteral(resourceName: "tip_menu")]
        menuNameArray = ["My Profile","Main Stream","Unread","Favorites","My Tips"]
        sectionItems2 = ["My Profile","Main Stream","Unread","Favorites","My Tips"]
        sectionItems1 = ["My Profile","Favorites","My Tips"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)  as! MenuCollectionViewCell
        
//        cell.bgView.layer.cornerRadius = 5
//        cell.bgView.layer.borderWidth = 1
//        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
       // cell.bgView.layer.masksToBounds = true
        
        cell.menuImage.image = menuImagesArray[indexPath.row]
        cell.menuLabel.text = menuNameArray[indexPath.row]
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 0:
            break
        case 1:
            break
        case 0:
            break
       
            
        default:
            break
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        return sectionItems1.count
        
        }
        return sectionItems2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font.withSize(10)
        if indexPath.section == 0{
        cell.textLabel?.text = sectionItems1[indexPath.row]
        }
        cell.textLabel?.text = sectionItems2[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "bussiness"
    }
        return "education"
    
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(displayP3Red: 89.0/255, green: 204/255, blue: 255/255, alpha: 0.5)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}
