//
//  ProfileViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 25/04/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var eventStartText: UITextField!
    let sam = UIButton()
    let datePicker = UIDatePicker()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      

        datePicker.datePickerMode = .date
      //  datePicker.backgroundColor
        sam.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        sam.backgroundColor = UIColor.red
        view.addSubview(sam)
        sam.addTarget(self, action: #selector(samClick(sender:)), for: .touchUpInside)
        eventStartText.delegate = self
        var components = DateComponents()
        components.year = -18
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -100
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        print(minDate ?? 000)
        print(maxDate ?? 000)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextField Delegate
//    func datePickerChanged(sender: UIDatePicker) {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        eventStartText.text = formatter.string(from: sender.date)
//        
//        print("Try this at home")
//    }
    func samClick(sender: UIButton) {
    
        if eventStartText.inputView == datePicker{
        eventStartText.inputView = nil
        eventStartText.keyboardType = .numberPad
        }
        else{
        
        eventStartText.inputView = datePicker
        }
    
    
    }
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
}
