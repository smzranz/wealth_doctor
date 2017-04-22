//
//  StateViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 26/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class StateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedState = ""
    var selectedCity = ""
    var selectedIndex :Int = 1
    
    @IBOutlet var citiesBtn: UIButton!
    
    @IBOutlet var statesBtn: UIButton!
let pickerTableView = UITableView()
 var pickerData = [String]()
    var pickerData1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         stateLoad()
         pickerTableView.isHidden = false
        stateLoad()
        pickerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        citiesBtn.isHidden = true
        pickerTableView.delegate = self
        pickerTableView.dataSource = self
        citiesBtn.layer.cornerRadius = 8
        citiesBtn.layer.borderColor = UIColor.darkGray.cgColor
        citiesBtn.layer.borderWidth = 1
        statesBtn.layer.cornerRadius = 8
        statesBtn.layer.borderColor = UIColor.darkGray.cgColor
        statesBtn.layer.borderWidth = 1

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 2{
        return pickerData1.count
        }
        return pickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if selectedIndex == 1 {
        cell.textLabel?.text = pickerData[indexPath.row]
        }
        else {
            cell.textLabel?.text = pickerData1[indexPath.row]

        
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == 1 {
        
        selectedState = pickerData[indexPath.row]
            statesBtn.setTitle(selectedState, for: .normal)
            citiesBtn.isHidden = false

        
        }
        else {
        
        selectedCity = pickerData1[indexPath.row]
            citiesBtn.setTitle(selectedCity, for: .normal)

        }
        pickerTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    @IBAction func stateSelect(_ sender: Any) {
        
        self.selectedIndex = 1
        pickerTableView.reloadData()
        self.pickerTableView.isHidden = false
        
        self.pickerTableView.frame = CGRect(x: 30, y: 300, width: 300, height: 200)
        self.view.addSubview(pickerTableView)
    }
    
    
    @IBAction func citiesChange(_ sender: Any) {
         self.selectedIndex = 2
             pickerData1 = [String]()
        
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CITIES WHERE stateID = '\(selectedState)' ;")
        
        
        while userdata.next() {
            let x = userdata.string(forColumn: "cityNAME")
            
            
            self.pickerData1.append(x!)
            
            
            
        }
      
        
        pickerTableView.frame = CGRect(x: 30, y: 360, width: 300, height: 200)
        self.view.addSubview(pickerTableView)
        pickerTableView.reloadData()

  pickerTableView.isHidden = false
        
        
    }
    
    func stateLoad(){
    
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from STATES;")
        while userdata.next() {
            let x = userdata.string(forColumn: "stateNAME")
            
            
            pickerData.append(x!)
            
            
            
            
        }
        pickerTableView.reloadData()
    
    }
    
    
    @IBAction func NextBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toArticle", sender: self)
        
    }
    

}
