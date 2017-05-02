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
    var IndexToSend:Int = 0
    
    var city_id = ""
    var state_id = ""
    @IBOutlet var citiesBtn: UIButton!
    
    @IBOutlet var statesBtn: UIButton!
let pickerTableView = UITableView()
 var pickerData = [String]()
    
    var selectedData = [String]()
    var selectedData1 = [String]()
    var pickerData1 = [String]()
    let name = UserDefaults.standard.value(forKey: "Name")
    let mobileNumber = UserDefaults.standard.value(forKey: "mobile")
    let mr = UserDefaults.standard.value(forKey: "Mr")
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
        city_id = selectedData1[indexPath.row]
            state_id = selectedData[indexPath.row]
            citiesBtn.setTitle(selectedCity, for: .normal)

            IndexToSend = indexPath.row
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
        
        self.pickerTableView.frame = CGRect(x: 30, y: 330, width: 300, height: 200)
        self.view.addSubview(pickerTableView)
    }
    
    
    @IBAction func citiesChange(_ sender: Any) {
         self.selectedIndex = 2
             pickerData1 = [String]()
        selectedData1 = [String]()
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CITIES WHERE stateID = '\(selectedState)' ;")
        
        
        while userdata.next() {
            let x = userdata.string(forColumn: "cityNAME")
            let y = userdata.string(forColumn: "cityID")
            let z = userdata.string(forColumn: "stateID")
            
            self.pickerData1.append(x!)
            self.selectedData1.append(y!)
             selectedData.append(z!)
            
            
        }
      
        
        pickerTableView.frame = CGRect(x: 30, y: 390, width: 300, height: 200)
        self.view.addSubview(pickerTableView)
        pickerTableView.reloadData()

  pickerTableView.isHidden = false
        
        
    }
    
    func stateLoad(){
    
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from STATES;")
        while userdata.next() {
            let x = userdata.string(forColumn: "stateNAME")
          //  let y = userdata.string(forColumn: "stateID")
            
            
            pickerData.append(x!)
           
            
            
            
        }
        pickerTableView.reloadData()
    
    }
    
    
    @IBAction func NextBtn(_ sender: Any) {
        
            
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                
             //   self.performSegue(withIdentifier: "stateToNews", sender: self)
                let scriptUrl = "http://www.indianmoney.com/wealthDoctor/ios/updatepro.php"
                
                let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
                
                let myUrl = URL(string: urlWithParams);
                
                var request = URLRequest(url:myUrl!)
                
                let postString = "name=\(name!)&mobile=\(mobileNumber!)&tittle=\(mr)&city_id=\(city_id)&state_id=\(state_id)"
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
                                self.displaymyalertmessage(usermessage: "serverdown")
                            }
                            return
                        }
                        if responseString == "null\n"{
                            
                        }
                        else{
                            
                            do {
                                
                                if let convertedJsonDictioanry = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                    
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "toArticle", sender: self)
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
       
    
    
    
    func displaymyalertmessage (usermessage:String) {
        let myalert = UIAlertController(title: "WARNING", message: usermessage, preferredStyle: UIAlertControllerStyle.alert )
        
        let okaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)

}
}
