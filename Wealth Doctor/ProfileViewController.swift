//
//  ProfileViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 25/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var changedMr = ""
    var changedjob = ""
    var changedlanguage = ""
    var changedstatus = ""
    
    var selectedIndex : Int = 0
    var pickerTableView = UITableView()
    @IBOutlet var eventStartText: UITextField!
    let sam = UIButton()
   
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
  let deviceID = UIDevice.current.identifierForVendor!.uuidString
     let mobileNumber = UserDefaults.standard.value(forKey: "mobileverified")
    let datePicker = UIDatePicker()
    var otp_req = [String]()
    var q_choices = [String]()
    var q_hint = [String]()
    var q_id = [String]()
    var q_type = [String]()
    var qanswer = [String]()
    var question = [String]()
    
    @IBOutlet weak var bgView8: UIView!
     @IBOutlet weak var bgView7: UIView!
     @IBOutlet weak var bgView6: UIView!
     @IBOutlet weak var bgView5: UIView!
     @IBOutlet weak var bgView4: UIView!
     @IBOutlet weak var bgView3: UIView!
     @IBOutlet weak var bgView2: UIView!
     @IBOutlet weak var bgView1: UIView!
    
    
    
    @IBOutlet var saveBtnOutlet: UIButton!
    
    
    

    @IBOutlet var titleTxt: UITextField!
    @IBOutlet var NameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    @IBOutlet var dobTxt: UITextField!
    @IBOutlet var addressTxt: UITextField!
    @IBOutlet var occupationTxt: UITextField!
    @IBOutlet var languagesTxt: UITextField!
    @IBOutlet var maritalStatusTxt: UITextField!
    
    
    var mr = [String]()
    var job = [String]()
var language = [String]()
    var status = [String]()
    var mr1 = [String]()
    var job1 = [String]()
    var language1 = [String]()
    var status1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtnOutlet.layer.cornerRadius = 6
        saveBtnOutlet.layer.masksToBounds = true
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -18
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        datePicker.datePickerMode = .date
        
        self.dobTxt.inputView = self.datePicker
        self.datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
        
        pickerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      
        pickerTableView.delegate = self
        pickerTableView.dataSource = self
        
       pickerTableView.bounces = false
        pickerTableView.layer.cornerRadius = 5
        pickerTableView.layer.borderColor = UIColor.darkGray.cgColor
        pickerTableView.layer.borderWidth = 1
        self.navigationItem.title = "Profile"
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "menu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //btn1.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btn1.addTarget(self, action: #selector(leftMenuPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButton(item1, animated: true)
loadProfile()
        
        bgView1.layer.cornerRadius = 6
        bgView2.layer.cornerRadius = 6
        bgView3.layer.cornerRadius = 6
        bgView4.layer.cornerRadius = 6
        bgView5.layer.cornerRadius = 6
        bgView6.layer.cornerRadius = 6
        bgView7.layer.cornerRadius = 6
        bgView8.layer.cornerRadius = 6
        
      
        
        datePicker.datePickerMode = .date

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = mr[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == 1{
        
        changedMr = mr1[indexPath.row]
            titleTxt.text = mr[indexPath.row]
        }
        else if selectedIndex == 2{
            changedjob = mr1[indexPath.row]
            occupationTxt.text = mr[indexPath.row]
        
        }
        else if selectedIndex == 3{
            changedlanguage = mr1[indexPath.row]
            languagesTxt.text = mr[indexPath.row]
            
        }else{
            changedstatus = mr1[indexPath.row]
            
            maritalStatusTxt.text = mr[indexPath.row]
        }
        
    
            
            
                pickerTableView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
//    
//    func samClick(sender: UIButton) {
//    
//        if eventStartText.inputView == datePicker{
//        eventStartText.inputView = nil
//        eventStartText.keyboardType = .numberPad
//        }
//        else{
//        
//        eventStartText.inputView = datePicker
//        }
//    
//    
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        eventStartText.inputView = datePicker
//        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)        
//        print("This Worked")
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        eventStartText.resignFirstResponder()
//        return true
//    }
//    
//    // MARK: Helper Methods
//    func closekeyboard() {
//        self.view.endEditing(true)
//    }
//    
//    // MARK: Touch Events
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        closekeyboard()
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func loadProfile(){
        
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
          //  actstart()
            let scriptUrl = "http://www.indianmoney.com/wealthDoctor/myprofile.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=\(mobileNumber!)&gcm=\(deviceID)"
            request.httpBody = postString.data(using: .utf8)
            
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let responseString = String(data: data!, encoding: .utf8){
                    // print("responseString = \(responseString)")
                 //   self.actstop()
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
                            
                            if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                //   print(convertedJsonIntoArray)
                                
                                if let nestedDictionary = convertedJsonIntoArray["qarray"] as? [String:Any] {
//
                                    let dic = nestedDictionary["que_and_ans"] as! NSArray
//                                   
                                    
                                    for i in 0...dic.count-1 {
                                      
                                        let elementes = dic[i] as! [String:Any]
                                    let otp_req = elementes["otp_req"] as! String
                                        let q_choices = elementes["q_choices"] as! String
                                        let q_hint = elementes["q_hint"] as! String
                                        let q_id = elementes["q_id"] as! String
                                        let q_type = elementes["q_type"] as! String
                                        let qanswer = elementes["qanswer"] as! String
                                        let question = elementes["question"] as! String
                                    self.otp_req.append(otp_req)
                                        self.q_choices.append(q_choices)
                                        self.q_hint.append(q_hint)
                                        self.q_id.append(q_id)
                                        self.q_type.append(q_type)
                                        self.qanswer.append(qanswer)
                                        self.question.append(question)
                                        
                                    
                                    
                                    }
                                    
                                    
                                    
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.titleTxt.text = self.qanswer[0]
                                        self.NameTxt.text = self.qanswer[1]
                                        
                                        if self.qanswer[2] == "0"{
                                            
                                            self.EmailTxt.attributedPlaceholder = NSAttributedString(string: self.question[2], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.EmailTxt.text = self.qanswer[2]
                                        }
                                        if self.qanswer[3] == "0"{
                                            
                                            self.dobTxt.attributedPlaceholder = NSAttributedString(string: self.question[3], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.dobTxt.text = self.qanswer[3]
                                        }
                                        if self.qanswer[4] == "0"{
                                            
                                            self.addressTxt.attributedPlaceholder = NSAttributedString(string: self.question[4], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.addressTxt.text = self.qanswer[4]
                                        }
                                        if self.qanswer[5] == "0"{
                                            
                                            self.occupationTxt.attributedPlaceholder = NSAttributedString(string: self.question[5], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.occupationTxt.text = self.qanswer[5]
                                        }
                                        if self.qanswer[6] == "0,"{
                                            
                                            self.languagesTxt.attributedPlaceholder = NSAttributedString(string: self.question[6], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.languagesTxt.text = self.qanswer[6]
                                        }
                                        if self.qanswer[7] == "0"{
                                            
                                            self.maritalStatusTxt.attributedPlaceholder = NSAttributedString(string: self.question[7], attributes: [NSForegroundColorAttributeName:UIColor.orange])
                                        }
                                        else{
                                            self.maritalStatusTxt.text = self.qanswer[7]
                                            
                                        }
                                        
                                        
//                                        let mrSeperated = self.q_choices[0].components(separatedBy: ",")
//                                        for i in 0...mrSeperated.count-1{
//                                        let names = mrSeperated[i].components(separatedBy: "_")
//                                            self.mr1.append(names[0])
//                                            self.mr.append(names[1])
//                                        
//                                        }
//                                        let mrSeperated2 = self.q_choices[5].components(separatedBy: ",")
//                                        for i in 0...mrSeperated2.count-1{
//                                            let names = mrSeperated[i].components(separatedBy: "_")
//                                            self.job1.append(names[0])
//                                            self.job.append(names[1])
//                                            
//                                        }
//                                        let mrSeperated3 = self.q_choices[6].components(separatedBy: ",")
//                                        for i in 0...mrSeperated3.count-1{
//                                            let names = mrSeperated[i].components(separatedBy: "_")
//                                            self.language1.append(names[0])
//                                            self.language.append(names[1])
//                                            
//                                        }
//                                        let mrSeperated4 = self.q_choices[7].components(separatedBy: ",")
//                                        for i in 0...mrSeperated4.count-1{
//                                            let names = mrSeperated[i].components(separatedBy: "_")
//                                            self.status1.append(names[0])
//                                            self.status.append(names[1])
//                                            
//                                        }
                                        
                                        //  self.performSegue(withIdentifier: "mobiletootp", sender: self)
                                    }
//                                    
                                  //  print(nestedDictionary)
                                }
                                
                                // self.actstop()
                                
                                else{
                                    DispatchQueue.main.async {
                                           self.displaymyalertmessage(usermessage: "please logout from other devices")
                                    }
                                }
                                
                                
                               
                                
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                     //   self.displaymyalertmessage(usermessage: "serverdown")
                    }
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func leftMenuPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MenuViewController") as! MenuViewController
        viewController.sideSelected = 0
        showAnimationLeftToRight()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    func showAnimationLeftToRight() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
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
    
    
    @IBAction func btn1(_ sender: Any) {
        selectedIndex = 1
        mr = [String]()
        mr1 = [String]()
        let mrSeperated = self.q_choices[0].components(separatedBy: ",")
        for i in 0...mrSeperated.count-1{
            let names = mrSeperated[i].components(separatedBy: "_")
            self.mr1.append(names[0])
            self.mr.append(names[1])
            
        }
        pickerTableView.reloadData()
        pickerTableView.frame = CGRect(x: 142, y: 145, width: Int(self.languagesTxt.frame.width), height: self.mr.count*44)
       
         self.view.addSubview(pickerTableView)
    }
    
    
    @IBAction func btn2(_ sender: Any) {
        selectedIndex = 2
        mr = [String]()
        mr1 = [String]()
        let mrSeperated = self.q_choices[5].components(separatedBy: ",")
        for i in 0...mrSeperated.count-1{
            let names = mrSeperated[i].components(separatedBy: "_")
            self.mr1.append(names[0])
            self.mr.append(names[1])
            
        }
        pickerTableView.reloadData()
        pickerTableView.frame = CGRect(x: 142, y: 409, width: self.languagesTxt.frame.width, height: 200)
       
        self.view.addSubview(pickerTableView)
    }
    
    @IBAction func btn3(_ sender: Any) {
        selectedIndex = 3
        mr = [String]()
        mr1 = [String]()
        let mrSeperated = self.q_choices[6].components(separatedBy: ",")
        for i in 0...mrSeperated.count-1{
            let names = mrSeperated[i].components(separatedBy: "_")
            self.mr1.append(names[0])
            self.mr.append(names[1])
            
        }
        pickerTableView.reloadData()
        pickerTableView.frame = CGRect(x: 142, y: 462, width: self.languagesTxt.frame.width, height: 200)
        
        self.view.addSubview(pickerTableView)
    }
    
    
    @IBAction func btn4(_ sender: Any) {
        selectedIndex = 4
        mr = [String]()
        mr1 = [String]()
        let mrSeperated = self.q_choices[7].components(separatedBy: ",")
        for i in 0...mrSeperated.count-1{
            let names = mrSeperated[i].components(separatedBy: "_")
            self.mr1.append(names[0])
            self.mr.append(names[1])
            
        }
        pickerTableView.reloadData()
        pickerTableView.frame = CGRect(x: 142, y: 512, width: Int(self.languagesTxt.frame.width), height: self.mr.count*44)
      
        self.view.addSubview(pickerTableView)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        // let dateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dobTxt.text = formatter.string(from: sender.date)
        
        print("Try this at home")
    }
}
