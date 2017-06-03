//
//  ChatViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 05/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
    var multiSelectionIsEnable :Bool = false
    
    var noSecondData :Bool = false

    @IBOutlet weak var doneBtnOutlet: UIButton!
    
    @IBOutlet weak var multiSelectTableview: UITableView!
    var selectedoptions = ""
    var multiSelectDisplayArray = [String]()
    var multiSelectSentArray = [String]()
    var selectedTextFromDropDown = ""
    var textInputFromPopUP = ""
    
    var dropDownTableview = UITableView()
    var disable = [String]()
    
    @IBOutlet var popUpDrownDownTxtField: UITextField!
    
    
    @IBOutlet weak var popUpCallBtn: UIButton!
    @IBOutlet weak var popupBgView: UIView!
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var popUpDropDownBtn: UIButton!
    
    @IBOutlet weak var popUpTxtField: UITextField!
    
    var lastIndexPath : Int = 0
    var isChatLoadEnable:Bool = false
    
    var secondPart : String!
    var selectedTag = ""
    var adviceOn = ""
    var type = ""
    var i = ""
    var questionId = ""
let mobileNumber = UserDefaults.standard.value(forKey: "mobileverified")

   // let mobileNumber = "9567019109"
    @IBOutlet var chatTxt: UITextField!
    @IBOutlet weak var textFieldBgView: UIView!
    let datePicker = UIDatePicker()
    @IBOutlet weak var loaderView: UIView!
    var squareData = [String]()
    var curlyData = [String]()
    var tags = [String]()
    var pickerDisplayArray = [String]()
    var serverGeneratedArray = [String]()
     var totalWidth : CGFloat = 0.0
    var isTagPressed : Bool = false
    var selectedTagFromNews = ""
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let picker = UIPickerView()
    
    @IBOutlet var chatTableView: UITableView!
    var serverChatText = [String]()
    var chat_id = [String]()
    var color_id = [String]()
    var chatTime   = [String]()
    var ansId = ""
    var productId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.multiSelectTableview.isHidden = true
        self.doneBtnOutlet.isHidden = true
        popUpCallBtn.isHidden = true
        navigationController?.hidesBarsOnSwipe = false
        picker.backgroundColor = UIColor.white
        datePicker.backgroundColor = UIColor.white
        textFieldBgView.isHidden = true
        dropDownTableview.layer.borderWidth = 1
        dropDownTableview.layer.cornerRadius = 5
        dropDownTableview.layer.borderColor = UIColor.lightGray.cgColor
        dropDownTableview.delegate = self
        dropDownTableview.dataSource = self
      //  dropDownTableview.isHidden = true
        dropDownTableview.separatorStyle = .singleLine
        dropDownTableview.bounces = false
        dropDownTableview.register(UITableViewCell.self, forCellReuseIdentifier: "autocell")
        dropDownTableview.backgroundColor = UIColor(colorLiteralRed: 255, green: 255, blue: 155, alpha: 1)
        
        
       
        
        popUpDropDownBtn.layer.cornerRadius = 5
        popUpDropDownBtn.layer.borderColor = UIColor.lightGray.cgColor
        popUpDropDownBtn.layer.borderWidth = 1
        popUpDropDownBtn.layer.masksToBounds = true
        
        popUpTxtField.layer.cornerRadius = 5
        popUpTxtField.layer.borderColor = UIColor.lightGray.cgColor
        popUpTxtField.layer.borderWidth = 1
        popUpTxtField.layer.masksToBounds = true
        self.popupBgView.isHidden = true
        popUpCallBtn.isHidden = true
        self.loaderView.isHidden = true
        picker.delegate = self
        picker.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.dropDownBgViewAction(sender:)))
        gesture.delegate = self
        self.popupBgView.addGestureRecognizer(gesture)
     //   popupBgView.addTarget(self, action: #selector(popUpDropDownBtnClick()), for: .touchUpInside)
        popUpDropDownBtn.addTarget(self, action: #selector(popUpDropDownBtnClick(sender:)), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = false
        if UserDefaults.standard.value(forKey: "chat") != nil{
           
            
          
            if isTagPressed == true{
                let ans_Id = UserDefaults.standard.value(forKey: "ans_id") as! String
                let product_id = UserDefaults.standard.value(forKey: "product_id") as! String
                dataToServer(chatTxt1: selectedTagFromNews, ans_id: ans_Id, product_id: product_id,colorEnable:true)
                
            }
              lodingasending()
        }
        else {
           
            chatLoad()
            if isTagPressed == true{
                let ans_Id = UserDefaults.standard.value(forKey: "ans_id") as! String
                let product_id = UserDefaults.standard.value(forKey: "product_id") as! String
             dataToServer(chatTxt1: selectedTagFromNews, ans_id: ans_Id, product_id: product_id,colorEnable:true)
            
            }
            
        }
        
        chatTableView.backgroundView = UIImageView(image: UIImage(named: "chat_bg_image"))
        
        if UserDefaults.standard.value(forKey: "type")  != nil {
            let type1: String  = UserDefaults.standard.value(forKey: "type") as! String
            if type1 == "4"{
            //    self.chatTxt.inputView = self.picker
            }
        }
        
        
        //chatTableView.rowHeight = UITableViewAutomaticDimension
       // chatTableView.estimatedRowHeight = 300
        
        
        
        self.chatTableView.setNeedsLayout()
        self.chatTableView.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: PickeView
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
        return pickerArraySaved.count
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
    
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    var cn1:NSLayoutConstraint!;
    var cn111:NSLayoutConstraint!;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropDownTableview{
          //  let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
       return pickerDisplayArray.count
        }
        if tableView == multiSelectTableview{
            //  let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
            return pickerDisplayArray.count
        }
        return serverChatText.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropDownTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "autocell", for: indexPath) as UITableViewCell
            let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
            cell.textLabel?.text = pickerArraySaved[indexPath.row]
            return cell

        }
        if tableView == multiSelectTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "multicell", for: indexPath) as UITableViewCell
          //  let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
            cell.textLabel?.text = pickerDisplayArray[indexPath.row]
            if cell.isSelected
            {
                cell.isSelected = false
                if cell.accessoryType == UITableViewCellAccessoryType.none
                {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.none
                }
            }
            
            return cell
        
        
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        cell.userChatLabel.textColor = UIColor.black
        //  cell.userChatLabel.textAlignment = .right
        cell.userChatLabel.backgroundColor = UIColor.white
      
       
        cell.userChatLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.userChatLabel.preferredMaxLayoutWidth = self.chatTableView.frame.width-80
        cell.backgroundColor = UIColor.clear
        cell.tagCollectionView.backgroundColor = UIColor.clear
        
        cell.tagCollectionView.reloadData()
        
        
        
        
        cell.userChatLabel.layer.cornerRadius = 5
        cell.userChatLabel.layer.masksToBounds = true
        
        let type: String  = UserDefaults.standard.value(forKey: "type") as! String
         /// let chattime  = UILabel(frame: CGRect(x: 20, y:  cell.tagCollectionView.frame.origin.y-3, width: cell.tagCollectionView.frame.width-40, height: 14) )
        
        
        let chattime  = UILabel(frame: CGRect(x: 20, y:  cell.frame.height-10, width: view.frame.width-40, height: 10) )
       
     //  sleep(4)
        
        
        if type == "2" && indexPath.row == serverChatText.count - 1{
            totalWidth = 0.0
            if squareData.count > 0{
            for i in 0...squareData.count-1{
                
                let size = (squareData[i] as NSString).size(attributes: nil)
                let width = size.width
                
                totalWidth = totalWidth + width
                
            }
            
            }
            
            cell.tagCollectionView.isHidden = false
            cell.collectionViewHeight.constant = 30+(totalWidth/(view.frame.width))*35
            //+(totalWidth/(view.frame.width))*35
            
        }
        else{
             cell.collectionViewHeight.constant = 0
            cell.tagCollectionView.isHidden = true
            
        }
        if serverChatText.isEmpty {
            
        }else{
            
            
            
            if chat_id[indexPath.row] == "0"{
                
                
                for constraint in cell.contentView.constraints{
                    
                    if constraint.identifier == "lefticon"{
                        
                        cell.contentView.removeConstraint(constraint)
                        
                    }
                    
                    if constraint.identifier == "rightCon"{
                        
                        cell.contentView.removeConstraint(constraint)
                        
                    }
                }
                
                chattime.textAlignment = .left
              //  cell.userChatLabel.textColor = UIColor.black
               // cell.userChatLabel.backgroundColor = UIColor.white
               // cell.userChatLabel.textAlignment = .left
                
                cn1 = NSLayoutConstraint(item:cell.userChatLabel, attribute: .leading, relatedBy: .equal, toItem:cell.contentView ,attribute: .leadingMargin, multiplier: 1.0, constant: 0)
                cn1.identifier="lefticon"
                //
                let cn12 = NSLayoutConstraint(item: cell.userChatLabel, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .topMargin, multiplier: 1.0, constant: 3)
                
              //  let cn13 = NSLayoutConstraint(item: cell.tagCollectionView, attribute: .top, relatedBy: .equal, toItem: cell.userChatLabel, attribute: .bottom, multiplier: 1.0, constant: 5)
                
               // cell.contentView.backgroundColor=UIColor.green
                
                cell.contentView.addConstraint(cn1)
                
                cell.contentView.addConstraint(cn12)
              //  cell.contentView.addConstraint(cn13)
              
            }
            else if chat_id[indexPath.row] == "1" {
                if color_id[indexPath.row] == "1"{
                    
                    
                    cell.userChatLabel.backgroundColor = UIColor(colorLiteralRed: 36.0/255, green: 157.0/255, blue: 202.0/255, alpha: 1.0)
                    cell.userChatLabel.textColor = UIColor.white
                    
                    
                }
               // cell.userChatTime.text=chatTime[indexPath.row]
                for constraint in cell.contentView.constraints{
                    
                    if constraint.identifier == "lefticon"{
                        
                        cell.contentView.removeConstraint(constraint)
                        
                    }
                    
                    if constraint.identifier == "rightCon"{
                        
                        cell.contentView.removeConstraint(constraint)
                        
                    }
                }
                
                  chattime.textAlignment = .right
                if color_id.isEmpty{}else{
            
                }
                cn111 = NSLayoutConstraint(item:cell.contentView, attribute: .trailingMargin, relatedBy: .equal, toItem:cell.userChatLabel ,attribute: .trailing, multiplier: 1.0, constant: 0)
                cn111.identifier="rightCon"
                let cn12 = NSLayoutConstraint(item: cell.userChatLabel, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .topMargin, multiplier: 1.0, constant: 3)
                
             //   let cn13 = NSLayoutConstraint(item: cell.tagCollectionView, attribute: .top, relatedBy: .equal, toItem: cell.userChatLabel, attribute: .bottom, multiplier: 1.0, constant: 5)
                
                
                
                
                cell.contentView.addConstraint(cn111)
                
                cell.contentView.addConstraint(cn12)
              //  cell.contentView.addConstraint(cn13)
                
            }
                
//
            else{
            
            }
            
            
            
            
            for lbl in cell.contentView.subviews{
                if lbl.tag == 1001{
                    lbl.removeFromSuperview()
                }
                
                
            }
            
            
          //    chattime.frame  =  CGRect(x: 20, y:  cell.frame.height-14, width: cell.tagCollectionView.frame.width-40, height: 14)
            chattime.textColor = UIColor.gray
            chattime.tag = 1001
            chattime.text=chatTime[indexPath.row]
            chattime.font = UIFont(name: "Helvetica", size: 8)
          //  chattime.backgroundColor = UIColor.red
           // cell.userChatTime.backgroundColor = UIColor.red
            
            
          //  cell.userChatLabel.font = UIFont(name: "Helvetica", size: 12)
           // cell.userChatTime.text=chatTime[indexPath.row]

            
            cell.userChatLabel.text = serverChatText[indexPath.row]
         
            if indexPath.row == serverChatText.count-1{
                cell.contentView.addSubview(chattime)
                
                        }
            else{
            if chat_id[indexPath.row] == chat_id[indexPath.row+1]{
                
               
                chattime.removeFromSuperview()
            }else{
                
               cell.contentView.addSubview(chattime)
                if chat_id[indexPath.row] == "1"{
                    
                  
                    
                }
                else{
                    
                //    cell.userChatLabel.backgroundColor = UIColor.white
                 //   cell.userChatLabel.textColor = UIColor.black
                }
                
            }
            }
        }
        
        
//        if isChatLoadEnable == true{
//            cell.alpha = 0.0
//        let delay = 6.0; //calculate delay
//       
//            if indexPath.row > lastIndexPath{
//                print(indexPath.row)
//                print(lastIndexPath)
//                sleep(3)
//       // UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
//            cell.alpha = 1.0
//      //  }, completion: nil)
//               
//                
//        }
//        }
      // sleep(2)
        
        return cell
       // let lastIndex : IndexPath = NSIndexPath(row: self.serverChatText.count - 1, section: 0) as IndexPath
        //   print(lastIndex)
        
       // self.chatTableView.scrollToRow(at: indexPath , at: .top, animated: false)
    }
    
//    var shownIndexes : [IndexPath] = []
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if isChatLoadEnable == true{
//            cell.alpha = 0.0
//            let delay = 6.0; //calculate delay
//            
//            if indexPath.row > lastIndexPath{
//                print(indexPath.row)
//                print(lastIndexPath)
//                
//                UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
//                    cell.alpha = 1.0
//                }, completion: nil)
//                
//              //  sleep(3)
//            }
//        }
//        if indexPath.row ==  serverChatText.count-1{
//            isChatLoadEnable = false
//            self.loaderView.isHidden = true
//        }
//        lastIndexPath = indexPath.row
//    }
    
    
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: self.chatTableView.frame.width-80, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        if tableView == dropDownTableview{
        
        return 44
        }
        if tableView == multiSelectTableview{
            //  let pickerArraySaved = UserDefaults.standard.stringArray(forKey: "pickerArray") ?? [String]()
            return 44
        }
        let heightOfRow = self.calculateHeight(inString:serverChatText[indexPath.row])
       
        
      // let size = (squareData[indexPath.row] as NSString).size(attributes: nil)
       let type1 = UserDefaults.standard.value(forKey: "type") as! String
        if type1 == "2" && indexPath.row == serverChatText.count-1{
            totalWidth = 0.0
            if squareData.count > 0{
            for i in 0...squareData.count-1{
                
                let size = (squareData[i] as NSString).size(attributes: nil)
                let width = size.width
                
                totalWidth = totalWidth + width
                
            }
            
        return (heightOfRow + 85+(totalWidth/(view.frame.width))*35)
            }
        
        }
        else if indexPath.row != serverChatText.count-1{
            if chat_id[indexPath.row] == chat_id[indexPath.row+1]{
            return (heightOfRow + 35)
        }
            if chat_id[indexPath.row] == "0"{
                
                return (heightOfRow + 45)
            }
            else{
                
                
            }
    }
        else{
           
        }

//            if chat_id[indexPath.row] == chat_id[indexPath.row+1]{
//            }else{
//               return (heightOfRow + 70+(totalWidth/(view.frame.width))*35)
//                
//                
//            }
        
//        if chat_id[indexPath.row] == "0"{
//        return (heightOfRow + 50)
//        }
        return (heightOfRow + 70)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropDownTableview{
            
            selectedTextFromDropDown = pickerDisplayArray[indexPath.row]
        dropDownTableview.removeFromSuperview()
            popUpDropDownBtn.setTitle(selectedTextFromDropDown, for: .normal)
        
        
        }
        if tableView == multiSelectTableview{
        
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell!.isSelected
            {
                cell!.isSelected = false
                if cell!.accessoryType == UITableViewCellAccessoryType.none
                {
                    cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                    
                    selectedoptions = selectedoptions+"-\(serverGeneratedArray[indexPath.row])"
                }
                else
                {
                    
                 selectedoptions = selectedoptions.replacingOccurrences(of: "-\(serverGeneratedArray[indexPath.row])", with: "")
                    cell!.accessoryType = UITableViewCellAccessoryType.none
                }
            }
            
        
        }
    }
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squareData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! TagsCollectionViewCell
       // cell.alpha = 0.0
        cell.backgroundColor = UIColor.clear
        cell.tagLabel.layer.cornerRadius = 5
        cell.tagLabel.layer.masksToBounds = true
       // cell.tagLabel.preferredMaxLayoutWidth = self.view.frame.width/2
        
        if squareData.isEmpty{
        }else {
            if indexPath.row<squareData.count{
           
            cell.tagLabel.text = squareData[indexPath.row]
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! TagsCollectionViewCell
        
        
        selectedTag = cell.tagLabel.text!
        collectionView.isHidden = true
        let ans_Id = UserDefaults.standard.value(forKey: "ans_id") as! String
        let product_id = UserDefaults.standard.value(forKey: "product_id") as! String
        dataToServer(chatTxt1: squareData[indexPath.row], ans_id: ans_Id, product_id: product_id,colorEnable:true)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // let collectionViewWidth = collectionView.bounds.size.width
        let size = (squareData[indexPath.row] as NSString).size(attributes: nil)
        return CGSize(width: size.width+6, height: 30)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatTxt.resignFirstResponder()
        return true
    }
    
    
    //MARK: OtherMethods
    
    func chatLoad(){
        
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            self.loaderView.isHidden = false
            let scriptUrl = "http://www.indianmoney.com/wealthDoctor/chatserver.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=\(mobileNumber as! String)&chatQuestion=hi&ans_id=0&product_id=0"
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
                    // print("responseString = \(responseString)")
                    //self.actstop()
                    if error != nil
                    {
                        print("error=\(error)")
                        DispatchQueue.main.async {
                            self.loaderView.isHidden = true
                            self.displaymyalertmessage(usermessage: "serverdown")
                        }
                        return
                    }
                    
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    
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
                                let disable = Int(convertedJsonIntoArray["desable"] as! String)
                                let url = convertedJsonIntoArray["url"] as! String
                                UserDefaults.standard.setValue(disable, forKey: "disable")
                                UserDefaults.standard.setValue(ans_id, forKey: "ans_id")
                                UserDefaults.standard.setValue(product_id, forKey: "product_id")
                                UserDefaults.standard.setValue(type as String, forKey: "type")
                                UserDefaults.standard.synchronize()
                                self.type = type
                                
                                
                                var fullNameArr : [String] = nestedString.components(separatedBy: ". ")
                                
                                let firstName : String  = fullNameArr.removeLast()
                                self.secondPart = firstName
                                UserDefaults.standard.set(firstName, forKey: "contents")
                                DataBaseManager.shared.ExecuteCommand(query: "insert into tags (advice, advice_id) values ( '\(self.secondPart!)', '\(0)');")
                                for i in 0..<fullNameArr.count {
                                    let dataFromServer = fullNameArr[i] as String
                                    
                                    DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time,color) values ( '\(type)', '\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)',0,DATETIME('now'),0);")
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                DispatchQueue.main.async {
                                     UserDefaults.standard.setValue("chat", forKey: "chat")
                                    if type == "4"{
                                      //  self.chatTxt.inputView = self.picker
                                    }
                                    
                              //      self.chatTableView.reloadData()
                                    self.lodingasending()
                                    self.loaderView.isHidden = true
                                    
                                    
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
        UserDefaults.standard.setValue(nil, forKeyPath: "pickerArray")
        UserDefaults.standard.synchronize()
        serverChatText = [String]()
        chat_id = [String]()
        chatTime = [String]()
        color_id = [String]()
        
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CHAT ;")
        while userdata.next() {
            let x = userdata.string(forColumn: "serverChat")
            let y = userdata.string(forColumn: "chat_id")
            let z = userdata.string(forColumn: "time")
            let w = userdata.string(forColumn: "color")
            let u = userdata.string(forColumn: "disable")

            
            serverChatText.append(x!)
            chat_id.append(y!)
            disable.append(u!)
            chatTime.append(z!)
            color_id.append(w!)
            
            
        
        }
        if disable[disable.count-1] == "1"{
            textFieldBgView.isHidden = true
            chatTxt.isHidden = true
        }
        else{
        
        textFieldBgView.isHidden = false
            chatTxt.isHidden = false
            self.chatTxt.inputView = nil
            self.chatTxt.keyboardType = .default
        }
   //     chatTableView.reloadData()
        userdata.close()
        if  UserDefaults.standard.value(forKey: "type") == nil{
            return
        }
        let type1 = UserDefaults.standard.value(forKey: "type") as! String
        if type1 == "2" {
            UserDefaults.standard.setValue(nil, forKey: "questionId")
            UserDefaults.standard.synchronize()
           // textFieldBgView.isHidden = true
            squareData = [String]()
          //
                let userdata = DataBaseManager.shared.fetchData(Query: "select * from tags ORDER BY slno DESC LIMIT 1;")
            
                while userdata.next() {
                    let x = userdata.string(forColumn: "advice")
                    i = x!
                  let value = UserDefaults.standard.string(forKey: "contents")
                    let curly = self.matches(for: "\\[.+?\\]", in: value!)
                    if curly.count > 0{
                        for i in 0...curly.count-1{
                            if let sam1 = curly[i] as? String {
                                let eee1 = sam1.replacingOccurrences(of: "[", with: "")
                                let last1 = eee1.replacingOccurrences(of: "]", with: "")
                                self.squareData.append(last1)
                                
                                
                                
                            //    self.chatTableView.reloadData()
                            }
                        }
                    }
                    //  let y = userdata.string(forColumn: "advice_id")
                    let square = self.matches(for: "\\{.+?\\}", in: value!)
                    if square.count > 0{
                        for i in 0...square.count-1{
                            if let sam = square[i] as? String {
                                let eee = sam.replacingOccurrences(of: "{", with: "")
                                let last = eee.replacingOccurrences(of: "}", with: "")
                                //  print(last)
                                
                                self.adviceOn = last
                                
                            }
                        }
                    }
                    if adviceOn != ""{
                    if self.type == "2" {
                       // textFieldBgView.isHidden = true
                        //  print(adviceOn)
                        serverChatText = [String]()
                        chat_id = [String]()
                        chatTime = [String]()
                        color_id = [String]()
                        DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time,color) values ( '\(type1)', '\(adviceOn)', '\(0)','\(0)','\(0)', '\(0)',\(1),DATETIME('now'),0);")
                        adviceOn = ""
                        let userdata = DataBaseManager.shared.fetchData(Query: "select * from CHAT ;")
                        while userdata.next() {
                            let x = userdata.string(forColumn: "serverChat")
                            let y = userdata.string(forColumn: "chat_id")
                            let z = userdata.string(forColumn: "time")
                             let w = userdata.string(forColumn: "color")
                            
                            serverChatText.append(x!)
                            chat_id.append(y!)
                            
                            chatTime.append(z!)
                            color_id.append(w!)
                        //    chatTableView.reloadData()
                            
                            
                        }
                        userdata.close()
                    }
                    }
                }
                 userdata.close()
              //  textFieldBgView.isHidden = true
        //    chatTxt.isHidden = true
                
           // }
        }
        if UserDefaults.standard.value(forKey: "questionId") != nil{
//            let rs = DataBaseManager.shared.fetchData(Query: "SELECT COUNT(*) as Count FROM questions")
//            while rs.next() {
                pickerDisplayArray = [String]()
                serverGeneratedArray = [String]()
             //   let count = rs.int(forColumn: "Count")
                
                let userdata = DataBaseManager.shared.fetchData(Query: "select * from questions ORDER BY slno DESC LIMIT 1;")
                while userdata.next() {
                    let x = userdata.string(forColumn: "q_choice")
                    let y = userdata.string(forColumn: "q_type")
                   // let qtype = y!
                    let q_choice = UserDefaults.standard.string(forKey: "q_choice")
                    let qtype = UserDefaults.standard.string(forKey: "q_type")
                    if qtype == "1"{
                    
                    self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        self.chatTxt.inputView = nil
                        self.chatTxt.keyboardType = .default
                    }
                    else if qtype == "2"{
                        self.textFieldBgView.isHidden = false
                        
                        self.chatTxt.isHidden = false
                        
                        if q_choice!.contains("YES") {
                        
                        
                            let q_choicesSeperated : [String] = x!.components(separatedBy: ",")
                            for i in 0..<q_choicesSeperated.count {
                                let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                                if q_choiceDisplay.count == 2{
                                    let choiceItemServer: String = q_choiceDisplay[0]
                                    let choiceDisplayItem : String = q_choiceDisplay[1]
                                    
                                    self.pickerDisplayArray.append(choiceDisplayItem)
                                    self.serverGeneratedArray.append(choiceItemServer)
                                    
                                }
                            }
                            }
                        else{
                            let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                            for i in 0..<q_choicesSeperated.count {
                                let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                                if q_choiceDisplay.count == 2{
                                    let choiceItemServer: String = q_choiceDisplay[0]
                                    let choiceDisplayItem : String = q_choiceDisplay[1]
                                    
                                    self.pickerDisplayArray.append(choiceDisplayItem.replacingOccurrences(of: "~", with: ","))
                                    self.serverGeneratedArray.append(choiceItemServer.replacingOccurrences(of: "~", with: ","))
                                    
                                }
                            }

                        }
                            UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                            UserDefaults.standard.synchronize()
                            self.chatTxt.attributedPlaceholder = NSAttributedString(string: "tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                            self.chatTxt.inputView = self.picker
                        
                    }
                    else if qtype == "3"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                    self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.inputView = nil
                        self.chatTxt.keyboardType = .numberPad
                    }
                    else if qtype == "4"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                        for i in 0..<q_choicesSeperated.count {
                            let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                            if q_choiceDisplay.count == 2{
                                let choiceItemServer: String = q_choiceDisplay[0]
                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                
                                self.pickerDisplayArray.append(choiceDisplayItem)
                                self.serverGeneratedArray.append(choiceItemServer)
                                
                            }
                        }
                        
                        UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                        UserDefaults.standard.synchronize()
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.chatTxt.inputView = self.picker
                        
                    }
                    else if qtype == "5"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        datePicker.datePickerMode = .date
                        
                        self.chatTxt.inputView = self.datePicker
                        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
                    }
                    else if qtype == "6"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                        for i in 0..<q_choicesSeperated.count {
                            let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                            if q_choiceDisplay.count == 2{
                                let choiceItemServer: String = q_choiceDisplay[0]
                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                
                                self.pickerDisplayArray.append(choiceDisplayItem)
                                self.serverGeneratedArray.append(choiceItemServer)
                                
                            }
                        }
                        multiSelectionIsEnable = true
                        self.popUpCallBtn.isHidden = false
                        self.multiSelectTableview.reloadData()
                    print("multiselect")
                    }
                    else if qtype == "7"{
                        
                        
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                        for i in 0..<q_choicesSeperated.count {
                            let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                            if q_choiceDisplay.count == 2{
                                let choiceItemServer: String = q_choiceDisplay[0]
                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                
                                self.pickerDisplayArray.append(choiceDisplayItem)
                                self.serverGeneratedArray.append(choiceItemServer)
                                
                            }
                            UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                            UserDefaults.standard.synchronize()
                            
                        }
                        textFieldBgView.isHidden = false
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.popUpCallBtn.isHidden = false
                        self.dropDownTableview.reloadData()
                        
                        self.popUpTxtField.attributedPlaceholder = NSAttributedString(string: "Input your value", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.popUpTxtField.inputView = nil
                        self.popUpTxtField.keyboardType = .default
                    }
                    else if qtype == "8"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                        for i in 0..<q_choicesSeperated.count {
                            let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                            if q_choiceDisplay.count == 2{
                                let choiceItemServer: String = q_choiceDisplay[0]
                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                
                                self.pickerDisplayArray.append(choiceDisplayItem)
                                self.serverGeneratedArray.append(choiceItemServer)
                                
                            }
                            UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                            UserDefaults.standard.synchronize()
                        
                    }
                        textFieldBgView.isHidden = false
                        
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.popUpCallBtn.isHidden = false
                        self.dropDownTableview.reloadData()
                        self.popUpTxtField.attributedPlaceholder = NSAttributedString(string: "Input a number", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.popUpTxtField.inputView = nil
                        self.popUpTxtField.keyboardType = .numberPad
                       
                        
                    }
                    else if qtype == "9"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                        for i in 0..<q_choicesSeperated.count {
                            let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                            if q_choiceDisplay.count == 2{
                                let choiceItemServer: String = q_choiceDisplay[0]
                                let choiceDisplayItem : String = q_choiceDisplay[1]
                                
                                self.pickerDisplayArray.append(choiceDisplayItem)
                                self.serverGeneratedArray.append(choiceItemServer)
                                
                            }
                            UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                            UserDefaults.standard.synchronize()
                            
                        }
                        textFieldBgView.isHidden = false
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        self.popUpCallBtn.isHidden = false
                        self.dropDownTableview.reloadData()
                        
                        
                    }
                    else if qtype == "10"{
                    
                    
                            self.textFieldBgView.isHidden = false
                            self.chatTxt.isHidden = false
                            let q_choicesSeperated : [String] = q_choice!.components(separatedBy: ",")
                            for i in 0..<q_choicesSeperated.count {
                                let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
                                if q_choiceDisplay.count == 2{
                                    let choiceItemServer: String = q_choiceDisplay[0]
                                    let choiceDisplayItem : String = q_choiceDisplay[1]
                                    
                                    self.pickerDisplayArray.append(choiceDisplayItem)
                                    self.serverGeneratedArray.append(choiceItemServer)
                                    
                                }
                                UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
                                UserDefaults.standard.synchronize()
                                
                            }
                            textFieldBgView.isHidden = false
                            self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                            self.popUpCallBtn.isHidden = false
                            self.dropDownTableview.reloadData()
                            self.popUpTxtField.attributedPlaceholder = NSAttributedString(string: "Select a date", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                            self.popUpTxtField.inputView = datePicker
                            
                            
                            
                        }
                    else if qtype == "11"{
                        self.textFieldBgView.isHidden = false
                        
                        self.chatTxt.isHidden = false
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        
//                        var components = DateComponents()
//                        components.year = -100
//                        let minDate = Calendar.current.date(byAdding: components, to: Date())
//                        
//                        components.year = -18
//                        let maxDate = Calendar.current.date(byAdding: components, to: Date())
                        
                        datePicker.minimumDate = Date()
                       // datePicker.maximumDate = maxDate
                        
                        datePicker.datePickerMode = .date
                        
                        self.chatTxt.inputView = self.datePicker
                        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
                    }
                    else if qtype == "12"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                        
                        //                        var components = DateComponents()
                        //                        components.year = -100
                        //                        let minDate = Calendar.current.date(byAdding: components, to: Date())
                        //
                        //                        components.year = -18
                        //                        let maxDate = Calendar.current.date(byAdding: components, to: Date())
                        
                        datePicker.maximumDate = Date()
                        // datePicker.maximumDate = maxDate
                        
                        datePicker.datePickerMode = .date
                        
                        self.chatTxt.inputView = self.datePicker
                        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
                    }
                    if qtype == "13"{
                        self.textFieldBgView.isHidden = false
                        self.chatTxt.isHidden = false
                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
                       
                        var components = DateComponents()
                        components.year = -100
                        let minDate = Calendar.current.date(byAdding: components, to: Date())
                        
                        components.year = -18
                        let maxDate = Calendar.current.date(byAdding: components, to: Date())
                        
                        datePicker.minimumDate = minDate
                        datePicker.maximumDate = maxDate
                        
                        datePicker.datePickerMode = .date
                        
                        self.chatTxt.inputView = self.datePicker
                        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
                        print("This Worked")
                       // self.chatTxt.inputView = self.picker
                    }
                    else{
//                    let q_choicesSeperated : [String] = x!.components(separatedBy: ",")
//                    for i in 0..<q_choicesSeperated.count {
//                        let q_choiceDisplay  = q_choicesSeperated[i].components(separatedBy: "_")
//                        if q_choiceDisplay.count == 2{
//                        let choiceItemServer: String = q_choiceDisplay[0]
//                        let choiceDisplayItem : String = q_choiceDisplay[1]
//                        
//                        self.pickerDisplayArray.append(choiceDisplayItem)
//                        self.serverGeneratedArray.append(choiceItemServer)
//                        
//                        }
//                    }
//            
//                    UserDefaults.standard.setValue(self.pickerDisplayArray, forKeyPath: "pickerArray")
//                    UserDefaults.standard.synchronize()
//                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "tap to input", attributes: [NSForegroundColorAttributeName:UIColor.orange])
//                        self.chatTxt.inputView = self.picker
//                    }
                    }
                 //   chatTableView.reloadData()
                    
                    
                }
            userdata.close()
          //  }
        }
        
        chatTableView.reloadData()
        DispatchQueue.main.async {
            let lastIndex : IndexPath = NSIndexPath(row: self.serverChatText.count - 1, section: 0) as IndexPath
            //   print(lastIndex)
            
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
            if noSecondData == true{
            
                let ans_Id = UserDefaults.standard.value(forKey: "ans_id")
                let product_id = UserDefaults.standard.value(forKey: "product_id")
                dataToServer(chatTxt1: chatTxt.text!, ans_id: ans_Id as! String, product_id: product_id as! String,colorEnable:true)
            
            }
           else if pickerDisplayArray.count > 0{
                let itemIndex = pickerDisplayArray.index(of: "\(chatTxt.text!)")
                
                let selecteditem = serverGeneratedArray[itemIndex!]
                //   print(chatTxt.text!)
                let ans_Id = UserDefaults.standard.value(forKey: "ans_id")
                let product_id = UserDefaults.standard.value(forKey: "product_id")
                dataToServer(chatTxt1: selecteditem, ans_id: ans_Id as! String, product_id: product_id as! String,colorEnable:true)
            }
            else{
                let ans_Id = UserDefaults.standard.value(forKey: "ans_id")
                let product_id = UserDefaults.standard.value(forKey: "product_id")
           dataToServer(chatTxt1: chatTxt.text!, ans_id: ans_Id as! String, product_id: product_id as! String,colorEnable:false)
            }
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
    
    func dataToServer(chatTxt1 :String, ans_id : String,product_id : String,colorEnable:Bool){
        
        
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
            // view.endEditing(true)
            
            self.loaderView.isHidden = false
            isChatLoadEnable = true
            
            //  self.lodingasending()
            
            let scriptUrl = "http://www.indianmoney.com/wealthDoctor/chatserver.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=\(mobileNumber as! String)&chatQuestion=\(chatTxt1)&ans_id=\(ans_id)&product_id=\(product_id)"
            request.httpBody = postString.data(using: .utf8)
            
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
               
                // print("responseString = \(responseString)")
                //self.actstop()
                if error != nil
                {
                    print("error=\(error)")
                    
                    DispatchQueue.main.async {
                        self.loaderView.isHidden = true
                        self.displaymyalertmessage(usermessage: "serverdown")
                    }
                    return
                }
                 if let responseString = String(data: data!, encoding: .utf8){
                if responseString == "null\n"{
                    
                }
                else{
                    
                    
                    do {
                        var chatQuestion = ""
                        let type1 = UserDefaults.standard.value(forKey: "type") as! String
//                        if type1 == "2"{
//                                                        //  print(chatQuestion)
//                            
//                        }
//                        else{
//                            
//                            
//                            //  print(self.chatTxt.text!)
//                        }
                        if (self.chatTxt.text?.isEmpty)!{
                            chatQuestion = chatTxt1

                        
                        }else{
                        chatQuestion = self.chatTxt.text!
                        
                        }
                        var color = "0"
                        if colorEnable == true{
                        color = "1"
                        
                        }
                        else{
                        color = "0"
                        }
                        
                     
                        
                        if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                               print(convertedJsonIntoArray)
                            let disable22 = UserDefaults.standard.integer(forKey: "disable")
                            DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, chat_id,ans_id,url,product_id,disable,serverChat,time,color) values ( 0, 1, '\(disable22)',0,0,0,'\(chatQuestion)',DATETIME('now'),'\(color)');")
                            
                            color = "0"
                            let nestedString = convertedJsonIntoArray["text"] as! String
                            if let type = convertedJsonIntoArray["type"] as? String {
                                let ans_id = convertedJsonIntoArray["ans_id"] 
                                let product_id = convertedJsonIntoArray["product_id"] as! String
                                let disable = convertedJsonIntoArray["desable"]
                                let url = convertedJsonIntoArray["url"] as! String
                                UserDefaults.standard.set(disable, forKey: "disable")
                                UserDefaults.standard.setValue(ans_id, forKey: "ans_id")
                                UserDefaults.standard.setValue(product_id, forKey: "product_id")
                                self.ansId = ans_id as! String
                                self.productId = product_id
                                if type == "4" {
                                    if let questionsArray = convertedJsonIntoArray["questions"] as? NSArray{
                                        if let questionArrayDict = questionsArray[0] as? [String:Any] {
                                            let q_choice = questionArrayDict["q_choices"] as! String
                                            let q_type = questionArrayDict["q_type"] as! String
                                            let q_id = questionArrayDict["q_id"] as! String
                                            let question = questionArrayDict["question"] as! String
                                            UserDefaults.standard.set(q_choice, forKey: "q_choice")
                                            UserDefaults.standard.set(q_type, forKey: "q_type")
                                            DataBaseManager.shared.ExecuteCommand(query: "insert into questions (q_choice, q_choice_id,q_type,q_id,question) values ( '\(q_choice)', '\(0)', '\(q_type)', '\(q_id)','\(question)');")
                                            
                                            
                                        }
                                    }
                                }
                                
                                UserDefaults.standard.setValue(type, forKey: "type")
                                UserDefaults.standard.synchronize()
                                self.type = type
                                var fullNameArr : [String] = nestedString.components(separatedBy: ". ")
                                if type == "2" {
                                    var firstName = ""
                                    if fullNameArr.count>1{
                                        self.noSecondData = false
                                     firstName  = fullNameArr.removeLast()
                                    }else{
                                        self.noSecondData = true
                                    firstName = fullNameArr[0]
                                    }
                                     // firstName  = fullNameArr.removeLast()
                                    self.secondPart = firstName
                                UserDefaults.standard.set(firstName, forKey: "contents")
                                    DataBaseManager.shared.ExecuteCommand(query: "insert into tags (advice, advice_id) values ('\(firstName)','\(0)');")
                                    for i in 0..<fullNameArr.count {
                                        let dataFromServer = fullNameArr[i] as String
                                        
                                        DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type,serverChat,ans_id,url,product_id,disable,chat_id,time,color) values ('\(type)','\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)','\(0)',DATETIME('now'),'\(color)');")
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                if type == "4"{
                                    self.questionId = type
                                    //  print(self.questionId)
                                    UserDefaults.standard.setValue(self.questionId, forKey: "questionId")
                                    UserDefaults.standard.synchronize()
                                    for i in 0..<fullNameArr.count {
                                        let dataFromServer = fullNameArr[i] as String
                                        
                                        DataBaseManager.shared.ExecuteCommand(query: "insert into CHAT (type, serverChat,ans_id,url,product_id,disable,chat_id,time,color) values ( '\(type)', '\(dataFromServer)', '\(ans_id)','\(url)','\(product_id)', '\(disable)',0,DATETIME('now'),'\(color)');")
                                        
                                        
                                    }
                                    
                                    
                                }else{
                                
                                    UserDefaults.standard.setValue(nil, forKey: "questionId")
                                    UserDefaults.standard.synchronize()
                                }
                                
                                DispatchQueue.main.async {
                                    self.chatTxt.text = ""
                                    if type == "4"{
                                     
                                    }
                                    else if type == "2"{
                                        self.chatTxt.attributedPlaceholder = NSAttributedString(string: "Chat", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
                                    }
                                    
                                  //  self.chatTableView.reloadData()
                                    self.lodingasending()
                                    self.loaderView.isHidden = true
                                    
                                    
                                }
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
    
    
    
    @IBAction func deleteAllChat(_ sender: Any) {
        
        DataBaseManager.shared.ExecuteCommand(query: "DELETE FROM CHAT;")
        DataBaseManager.shared.ExecuteCommand(query: "DELETE FROM tags;")
        DataBaseManager.shared.ExecuteCommand(query: "DELETE FROM questions;")
        UserDefaults.standard.setValue(nil, forKeyPath: "chat")
        UserDefaults.standard.synchronize()
        multiSelectionIsEnable = false
        self.multiSelectTableview.isHidden = true
        self.doneBtnOutlet.isHidden = true
        popUpCallBtn.isHidden = true
        popupBgView.isHidden = true
        popUpView.isHidden = true
//        self.chatTableView.reloadData()
         chatLoad()
       // loadView()
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
       // let dateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        chatTxt.text = formatter.string(from: sender.date)
        
        print("Try this at home")
    }
    
    @IBAction func popUpCancelBtn(_ sender: Any) {
         self.popupBgView.isHidden = true
        
    }
    
    @IBAction func popUpSubmitBtn(_ sender: Any) {
        
        if (popUpTxtField.text?.isEmpty)!{
        
        
        
        
        }
        else{
      textInputFromPopUP = popUpTxtField.text!
            
            
            self.popupBgView.isHidden = true
            self.popUpCallBtn.isHidden = true
            let totaltext = "\(textInputFromPopUP)_\(selectedTextFromDropDown)"
            chatTxt.endEditing(true)
            view.resignFirstResponder()
            chatTxt.text = totaltext
            let ans_Id = UserDefaults.standard.value(forKey: "ans_id") as! String
            let product_id = UserDefaults.standard.value(forKey: "product_id") as! String
        dataToServer(chatTxt1: totaltext, ans_id: ans_Id, product_id: product_id,colorEnable:false)
        }
    }
    
    @IBAction func addPopUp(_ sender: Any) {
        self.popupBgView.isHidden = false
        if multiSelectionIsEnable == true{
            self.multiSelectTableview.isHidden = false
            self.doneBtnOutlet.isHidden = false
            
        }
        else{
        self.popUpView.isHidden = false
        }
    }
    func popUpDropDownBtnClick(sender: UIButton) {
       
    dropDownTableview.frame = CGRect(x: 70, y: 330, width: Int(popUpDropDownBtn.frame.width), height: 44*5)
        view.addSubview(dropDownTableview)
    
    }
    
    func dropDownBgViewAction(sender : UITapGestureRecognizer) {
        
        self.multiSelectTableview.isHidden = true
        self.doneBtnOutlet.isHidden = true
        popupBgView.isHidden = true
        self.dropDownTableview.removeFromSuperview()
    }
    
    @IBAction func DoneBtn(_ sender: Any) {
        if selectedoptions == "" {}
        
        else{
            let ans_Id = UserDefaults.standard.value(forKey: "ans_id") as! String
            let product_id = UserDefaults.standard.value(forKey: "product_id") as! String
        dataToServer(chatTxt1: selectedoptions, ans_id: ans_Id, product_id: product_id,colorEnable:true)
            multiSelectionIsEnable = false
            self.popUpCallBtn.isHidden = true
            self.popupBgView.isHidden = true
        self.multiSelectTableview.isHidden = true
            self.doneBtnOutlet.isHidden = true
        }
        
        
    }
    
    
    @IBAction func callAction(_ sender: Any) {
        
        let myalert = UIAlertController(title: "Call", message: "Do u want to call", preferredStyle: UIAlertControllerStyle.alert )
        
        let noaction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callNumber(phoneNumber: "02261816111")
        }
        myalert.addAction(noaction)
        myalert.addAction(yesAction)
        self.present(myalert, animated: true, completion: nil)
        
        
        
    }
    func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}
