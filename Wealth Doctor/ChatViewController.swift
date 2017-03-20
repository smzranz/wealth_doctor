//
//  ChatViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 05/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    var secondPart : String!
    var selectedTag = ""
    var adviceOn = ""
    var type = ""
    var i = ""
    @IBOutlet var chatTxt: UITextField!
    var squareData = [String]()
     var curlyData = [String]()
    var tags = [String]()
    var pickerDisplayArray = [String]()
    var serverGeneratedArray = [String]()
    var pickerArray = ["YES","NO"]

    
var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let picker = UIPickerView()
    
    @IBOutlet var chatTableView: UITableView!
    var serverChatText = [String]()
    var chat_id = [String]()
    var chatTime   = [String]()
    var ansId = ""
    var productId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        
        self.chatTableView.setNeedsLayout()
        self.chatTableView.layoutIfNeeded()
        if UserDefaults.standard.value(forKey: "chat") != nil{
        
        lodingasending()
            
        }
        else {
        UserDefaults.standard.setValue("chat", forKey: "chat")
            chatLoad()
        }
        self.chatTableView.estimatedRowHeight = 200
        
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.backgroundView = UIImageView(image: UIImage(named: "chat_bg_image"))
        
        if UserDefaults.standard.value(forKey: "type")  != nil {
        let type1: String  = UserDefaults.standard.value(forKey: "type") as! String
        if type1 == "4"{
            self.chatTxt.inputView = self.picker
        }
        }
        
           }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    ///pickerView
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
        return pickerArraySaved[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type: String  = UserDefaults.standard.value(forKey: "type") as! String
        if type == "4"{
            let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
        chatTxt.text = pickerArraySaved[row]
        self.view.endEditing(false)
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverChatText.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
       cell.userChatLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = UIColor.clear
        cell.tagCollectionView.backgroundColor = UIColor.clear
        cell.bgView.backgroundColor = .clear
   
        cell.userChatLabel.layer.cornerRadius = 5
        cell.userChatLabel.layer.masksToBounds = true
        
        let type: String  = UserDefaults.standard.value(forKey: "type") as! String
        print(type)
        if type == "2" && indexPath.row == serverChatText.count - 1{
            
           cell.tagCollectionView.isHidden = false
            
        }
        else{
        
            cell.tagCollectionView.isHidden = true

        }
        if serverChatText.isEmpty {
        
        }else{
          

      //  cell.serverChatLabel.translatesAutoresizingMaskIntoConstraints = false
        if chat_id[indexPath.row] == "0"{
     cell.userChatLabel.addConstraint(NSLayoutConstraint(item: cell.userChatLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
           // cell.userChatLabel.preferredMaxLayoutWidth = self.view.frame.width/2
            cell.userChatLabel.backgroundColor = UIColor.white
   cell.userChatLabel.textAlignment = .left
            cell.userChatLabel.numberOfLines = 0
          NSLayoutConstraint(item: cell.userChatLabel, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1, constant:10).isActive = true
            
           NSLayoutConstraint(item: cell.userChatLabel, attribute: .leading, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: .leading, multiplier: 1, constant: 15).isActive = true
          NSLayoutConstraint(item: cell.contentView, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: cell.userChatLabel, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
      
            cell.userChatLabel.sizeToFit()
       
       //     NSLayoutConstraint.activate([verticalSpace,horizontalConstraint,bottomConstraint])
            
        }
        else if chat_id[indexPath.row] == "1" {
           
           
          //  cell.userChatLabel.preferredMaxLayoutWidth = self.view.frame.width/2
            cell.userChatLabel.textAlignment = .right
        cell.userChatLabel.backgroundColor = UIColor.gray
            cell.userChatLabel.addConstraint(NSLayoutConstraint(item: cell.userChatLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
            cell.userChatLabel.sizeToFit()
            NSLayoutConstraint(item: cell.userChatLabel, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1, constant: 10).isActive = true
           NSLayoutConstraint(item: cell.contentView, attribute: .trailing, relatedBy: .equal, toItem: cell.userChatLabel, attribute: .trailing, multiplier: 1, constant: 15).isActive = true
       NSLayoutConstraint(item: cell.contentView, attribute: .bottom, relatedBy: .equal, toItem: cell.userChatLabel, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
          //  NSLayoutConstraint.activate([horizontalConstraint,verticalSpace,bottomConstraint])
        }
        else{}
        
        cell.userChatLabel.text = serverChatText[indexPath.row]
                   }

        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squareData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! TagsCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.tagLabel.layer.cornerRadius = 5
        cell.tagLabel.layer.masksToBounds = true
     //   cell.tagLabel.preferredMaxLayoutWidth = 200
     
        if squareData.isEmpty{
        }else{
          
        cell.tagLabel.text = squareData[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! TagsCollectionViewCell
       
        
         selectedTag = cell.tagLabel.text!
        collectionView.removeFromSuperview()
        
        dataToServer(chatTxt: squareData[indexPath.row], ans_id: ansId, product_id: productId)
        squareData = []
        
    }
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatTxt.resignFirstResponder()
        return true
    }

    func chatLoad(){
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            
            let scriptUrl = "http://www.indianmoney.com/wealthDoctor/chatserver.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=9746594225&chatQuestion=hi&ans_id=0&product_id=0"
            request.httpBody = postString.data(using: .utf8)
            
            request.httpMethod = "POST"
        
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                let networkStatus = Reeachability().connectionStatus()
                switch networkStatus {
                case .Unknown, .Offline:
                    self.displaymyalertmessage(usermessage: "no internet connection")
                    print("no internet connection")
                default :

                let responseString = String(data: data!, encoding: .utf8)
                // print("responseString = \(responseString)")
                //self.actstop()
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
                        
                        if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                             //  print(convertedJsonIntoArray)
                            
                             let nestedString = convertedJsonIntoArray["text"] as! String
                            let type = convertedJsonIntoArray["type"] as! String
                            let ans_id = convertedJsonIntoArray["ans_id"] as! String
                            let product_id = convertedJsonIntoArray["product_id"] as! String
                            let disable = convertedJsonIntoArray["desable"] as! String
                            let url = convertedJsonIntoArray["url"] as! String
                            UserDefaults.standard.setValue(type as String, forKey: "type")
                            UserDefaults.standard.synchronize()
                            self.type = type
                            
                            
                            var fullNameArr : [String] = nestedString.components(separatedBy: ". ")
                            
                            let firstName : String  = fullNameArr.removeLast()
                             self.secondPart = firstName
                            
                            DataBaseManager.shared.ExecuteCommand(query: "insert into tags (advice, advice_id) values ( '\(self.secondPart!)', '\(0)');")
                            for i in 0..<fullNameArr.count {
                            let dataFromServer = fullNameArr[i] as String

                             DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time) values ( '\(type)', '\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)',0,DATETIME('now'));")
                           
                                
                                
                                

                            }

                          DispatchQueue.main.async {

                            if type == "4"{
                                self.chatTxt.inputView = self.picker
                                                            }
                                    
                                    self.chatTableView.reloadData()
                                    self.lodingasending()
                                    
                            

                                                         }
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        
                    }
                }
            }
            }
            task.resume()
            
        }
        
    }
    func lodingasending(){
        
        serverChatText = [String]()
        chat_id = [String]()
       chatTime = [String]()
        
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CHAT ;")
        while userdata.next() {
            let x = userdata.string(forColumn: "serverChat")
            let y = userdata.string(forColumn: "chat_id")
            let z = userdata.string(forColumn: "time")
            
                      serverChatText.append(x!)
            chat_id.append(y!)
 
            chatTime.append(z!)
        
          chatTableView.reloadData()

            
        }
        
       let type = UserDefaults.standard.value(forKey: "type")
        if type != nil {
            
             let rs = DataBaseManager.shared.fetchData(Query: "SELECT COUNT(*) as Count FROM tags")
                while rs.next() {
                  
                let count = rs.int(forColumn: "Count")
            
            let userdata = DataBaseManager.shared.fetchData(Query: "select * from tags where slno= '\(count)';")
            while userdata.next() {
                let x = userdata.string(forColumn: "advice")
                i = x!
                
                let curly = self.matches(for: "\\[.+?\\]", in: self.i)
                if curly.count > 0{
                    for i in 0...curly.count-1{
                        if let sam1 = curly[i] as? String {
                            let eee1 = sam1.replacingOccurrences(of: "[", with: "")
                            let last1 = eee1.replacingOccurrences(of: "]", with: "")
                            self.squareData.append(last1)
                            
                            
                        
                            self.chatTableView.reloadData()
                        }
                    }
                }
              //  let y = userdata.string(forColumn: "advice_id")
                let square = self.matches(for: "\\{.+?\\}", in: self.i)
                if square.count > 0{
                    for i in 0...square.count-1{
                        if let sam = square[i] as? String {
                            let eee = sam.replacingOccurrences(of: "{", with: "")
                            let last = eee.replacingOccurrences(of: "}", with: "")
                            print(last)
                            
                         self.adviceOn = last
                            
                        }
                    }
                }
                
                if self.type == "2" {
                    print(adviceOn)
                    serverChatText = [String]()
                    chat_id = [String]()
                    chatTime = [String]()
                    DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time) values ( '\(type!)', '\(adviceOn)', '\(0)','\(0)','\(0)', '\(0)',\(1),DATETIME('now'));")
                    let userdata = DataBaseManager.shared.fetchData(Query: "select * from CHAT ;")
                    while userdata.next() {
                        let x = userdata.string(forColumn: "serverChat")
                        let y = userdata.string(forColumn: "chat_id")
                        let z = userdata.string(forColumn: "time")
                        
                        serverChatText.append(x!)
                        chat_id.append(y!)
                        
                        chatTime.append(z!)
                        
                        chatTableView.reloadData()
                        
                        
                    }
  
                }
                else{
                }
                
                
            }
        }
        
        }
        DispatchQueue.main.async {
            let lastIndex : IndexPath = NSIndexPath(row: self.serverChatText.count - 1, section: 0) as IndexPath
            print(lastIndex)
            
            self.chatTableView.scrollToRow(at: lastIndex , at: .top, animated: false)
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

    @IBAction func chatSentBtn(_ sender: Any) {
        
        if (chatTxt.text?.isEmpty)! {
        
        
        }
        else{
            let itemIndex = pickerDisplayArray.index(of: "\(chatTxt.text!)")
            let selecteditem = serverGeneratedArray[itemIndex!]
            print(selecteditem)
            dataToServer(chatTxt: selecteditem, ans_id: ansId, product_id: productId)
        }
    }
    func matches(for regex: String, in text: String) -> [String] {
        do { let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = NSString(string: text)
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)
            }
        } catch let error
        {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func dataToServer(chatTxt :String, ans_id : String,product_id : String){
    
        
            let networkStatus = Reeachability().connectionStatus()
            switch networkStatus {
            case .Unknown, .Offline:
                displaymyalertmessage(usermessage: "no internet connection")
                print("no internet connection")
            default :
                // view.endEditing(true)
                
              

                
                //  self.lodingasending()
                self.chatTxt.text = ""
                let scriptUrl = "http://www.indianmoney.com/wealthDoctor/chatserver.php"
                
                let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
                
                let myUrl = URL(string: urlWithParams);
                
                var request = URLRequest(url:myUrl!)
                
                let postString = "mobile=9746594225&chatQuestion=\(chatTxt)&ans_id=\(ans_id)&product_id=\(product_id)"
                request.httpBody = postString.data(using: .utf8)
                
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    let responseString = String(data: data!, encoding: .utf8)
                    // print("responseString = \(responseString)")
                    //self.actstop()
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
                              
                                    DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, chat_id,ans_id,url,product_id,disable,serverChat,time) values ( 0, 1, 0,0,0,0,'\(chatTxt)',DATETIME('now'));")
                              
                                
                                
                                if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                      print(convertedJsonIntoArray)
                                    
                                    let nestedString = convertedJsonIntoArray["text"] as! String
                                    if let type = convertedJsonIntoArray["type"] as? String {
                                    let ans_id = convertedJsonIntoArray["ans_id"] as! String
                                    let product_id = convertedJsonIntoArray["product_id"] as! String
                                    let disable = convertedJsonIntoArray["desable"] as! String
                                    let url = convertedJsonIntoArray["url"] as! String
                                        self.ansId = ans_id
                                        self.productId = product_id
                                        if type == "4" {
                                        if let questionsArray = convertedJsonIntoArray["questions"] as? NSArray{
                                            if let questionArrayDict = questionsArray[0] as? [String:Any] {
                                             let q_choice = questionArrayDict["q_choices"] as! String
                                       
                                            let q_choicesSeperated : [String] = q_choice.components(separatedBy: ", ")
                                            for i in 0..<q_choicesSeperated.count {
                                                let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                                                let choiceItemServer: String = q_choiceDisplay[0]
                                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                                
                                                self.pickerDisplayArray.append(choiceDisplayItem)
                                                self.serverGeneratedArray.append(choiceItemServer)
                                               print(self.pickerDisplayArray)
                                                print(self.serverGeneratedArray)
                                            }
                                            
                                            }
                                        }
                                        }
                                        UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                                    UserDefaults.standard.setValue(type, forKey: "type")
                                    UserDefaults.standard.synchronize()
                                    self.type = type
                                    var fullNameArr : [String] = nestedString.components(separatedBy: ". ")
                                    if type == "2" {
                                    let firstName : String  = fullNameArr.removeLast()
                                    self.secondPart = firstName
                                    
                                    DataBaseManager.shared.ExecuteCommand(query: "insert into tags (advice, advice_id) values ( '\(self.secondPart!)', '\(0)');")
                                    for i in 0..<fullNameArr.count {
                                        let dataFromServer = fullNameArr[i] as String
                                        
                                        DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time) values ( '\(type)', '\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)',0,DATETIME('now'));")
                                        
                                        
                                        }
                                        
                                        
                                    }
                                    
                                    if type == "4"{
                                    
                                        for i in 0..<fullNameArr.count {
                                            let dataFromServer = fullNameArr[i] as String
                                            
                                            DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time) values ( '\(type)', '\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)',0,DATETIME('now'));")
                                            
                                            
                                        }

                                    
                                    }
                                    
                                    DispatchQueue.main.async {
                                        //
                                        if type == "4"{
                                            self.chatTxt.inputView = self.picker
                                        }
                                        
                                        self.chatTableView.reloadData()
                                        self.lodingasending()
                                        
                                        
                                        
                                    }
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
