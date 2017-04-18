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
        
        pickerTableView.delegate = self
        pickerTableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        }
        else {
        
        selectedCity = pickerData[indexPath.row]
            citiesBtn.setTitle(selectedCity, for: .normal)

        }
        pickerTableView.isHidden = true
    }

    @IBAction func stateSelect(_ sender: Any) {
        
        selectedIndex = 1
        pickerTableView.isHidden = false
        
        pickerTableView.frame = CGRect(x: 30, y: 300, width: 300, height: 500)
        self.view.addSubview(pickerTableView)
    }
    
    
    @IBAction func citiesChange(_ sender: Any) {
         selectedIndex = 2
        pickerTableView.isHidden = false
        
        pickerTableView.frame = CGRect(x: 30, y: 330, width: 300, height: 500)
         self.view.addSubview(pickerTableView)
        pickerData = [String]()
        
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CITIES WHERE stateID = '\(selectedState)' ;")
        while userdata.next() {
            let x = userdata.string(forColumn: "stateID")
            
            
            pickerData1.append(x!)
            
            
            
        }
        pickerTableView.reloadData()


        
        
    }
    
    func stateLoad(){
    
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from STATES;")
        while userdata.next() {
            let x = userdata.string(forColumn: "stateNAME")
            
            
            pickerData.append(x!)
            
            
            
            
        }
        pickerTableView.reloadData()
    
    }

}
