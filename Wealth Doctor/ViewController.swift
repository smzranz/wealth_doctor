//
//  ViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 26/02/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
        var images = [String]()
    var content = [String]()
    var id = [String]()
    var tag = [String]()
    var tittle = [String]()
    var likeCount = [String]()
    var likeStatus = [String]()
    var date = [String]()
    var knowMore = [String]()
    var knowMoreUrl = [String]()
    var tagId = [String]()
    var artTime = "old"
    
    
    
    @IBOutlet var newsArticleTableView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.value(forKey: "first") != nil{
         loadData()
            
           
        }
        else {
            UserDefaults.standard.setValue("first", forKey: "first")
            articleLoad(arttime: "\(artTime)", tag_id: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsArticlesCollectionViewCell
        let remoteImageUrlString = "\(images[indexPath.row])"
       
       // let imageUrl  = NSURL(string:remoteImageUrlString)!
        let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            
            
            
            print("Image with url \(remoteImageUrlString) is loaded")
            
        }
        if likeStatus[indexPath.row] == "0"{
            
            cell.likeBtn.isSelected = false
            
        }
        else {
            cell.likeBtn.isSelected = true
        }
       // cell.askBtn.addTarget(self, action: #selector(ask(sender:)), for: .touchUpInside)
        cell.askBtn.tag = indexPath.row
        cell.knowMorebtn.addTarget(self, action: #selector(knowMore(sender:)), for: .touchUpInside)
        cell.knowMorebtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        cell.likeBtn.layer.cornerRadius = cell.likeBtn.frame.height/2
        cell.likeBtn.layer.borderColor = UIColor.blue.cgColor
        cell.likeBtn.layer.borderWidth = 1
         cell.likeBtn.tag = indexPath.row
        cell.likeBtn.isUserInteractionEnabled = true
        cell.likeBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        cell.likeBtn.setImage(#imageLiteral(resourceName: "like_second"), for: .selected)
//cell.newsImage.sd_setImage(with: URL(string: remoteImageUrlString), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        cell.newsImage.sd_setImage(with: URL(string: remoteImageUrlString), placeholderImage: #imageLiteral(resourceName: "place_holder"), options: SDWebImageOptions.progressiveDownload, completed: block)
        
        
        cell.tittleLabel.text = tittle[indexPath.row]
      //  cell.knowMorebtn.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        cell.shareBtn.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        cell.newsContentLabel.text = content[indexPath.row]
        cell.likesCountLabel.text = "\(likeCount[indexPath.row]) Likes"
        cell.knowMorebtn.setTitle("\(knowMore[indexPath.row])", for: .normal)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height-20)
    }
    
    
    func articleLoad(arttime:String,tag_id:String){
    
    
        let scriptUrl = "http://www.indianmoney.com/wealthDoctor/ios/wd_articles.php"
        
        let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
        
        let myUrl = URL(string: urlWithParams);
        
        var request = URLRequest(url:myUrl!)
        
        let postString = "mobile=9746594225&art_time=\(arttime)&tag_id=\(tag_id)"
        request.httpBody = postString.data(using: .utf8)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            let responseString = String(data: data!, encoding: .utf8)
        //     print("responseString = \(responseString)")
            
            if error != nil
            {
                print("error=\(error)")
                DispatchQueue.main.async {
                  //  self.displaymyalertmessage(usermessage: "serverdown")
                }
                return
            }
            if responseString == "null\n"{
                
            }
            else{
                
                do {
                    
                    if let convertedJsonDictioanry = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                       //  print(convertedJsonDictioanry)
                        if let nestedString = convertedJsonDictioanry["news"] as? NSArray{
                            for i in 0..<nestedString.count {
                                
                                if let news = nestedString[i] as? NSDictionary {
                                    
                                   let a_id = news["a_id"] as! String
                                    let a_title = news["a_title"] as! String
                                    let a_content = news["a_content"] as! String
                                    let a_image = news["a_image"] as! String
                                    let tag_id = news["tag_id"] as! String
                                    let a_tag = news["a_tag"] as! String
                                 //   let a_audio_url = news["a_audio_url"] as! String
                    //    let a_video_url = news["a_video_url"] as! String
                                    let no_more_url = news["no_more_url"] as! String
                                 //   let a_content_sort = news["a_content_sort"] as! String
                                    let like_count = news["like_count"] as! String
                                    let n_date = news["n_date"] as! String
                                   // let like_status = news["like_status"] as! String
                                     DataBaseManager.shared.ExecuteCommand(query: "insert into NewsArticle (a_audio_url , a_content , a_content_sort ,a_id , a_image , a_tag ,a_title ,a_video_url ,like_count ,like_status ,n_date ,no_more_url,tag_id)values ( '\(0)', '\(a_content)', '\(0)','\(a_id)','\(a_image)', '\(a_tag)','\(a_title)','\(0)','\(like_count)',0,'\(n_date)','\(no_more_url)','\(tag_id)');")
                                    
                                }
                            }

                        }
                        
                        DispatchQueue.main.async {
                           self.loadData()
                            
                            //  self.performSegue(withIdentifier: "mobiletootp", sender: self)
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    
                }
            }
        }
        
        task.resume()
        
    }
    

    func loadData() {
        images = [String]()
         content = [String]()
         id = [String]()
         tag = [String]()
         tittle = [String]()
         likeCount = [String]()
         likeStatus = [String]()
         date = [String]()
         knowMore = [String]()
         tagId = [String]()
        knowMoreUrl = [String]()
    
        let userdata = DataBaseManager.shared.fetchData(Query: "select * from NewsArticle ;")
        while userdata.next() {
            let x = userdata.string(forColumn: "a_image")
            let y = userdata.string(forColumn: "a_title")
            let z = userdata.string(forColumn: "a_content")
            let a = userdata.string(forColumn: "n_date")
            let b = userdata.string(forColumn: "like_status")
            let c = userdata.string(forColumn: "no_more_url")
            let d = userdata.string(forColumn: "like_count")
            let e = userdata.string(forColumn: "a_tag")
            let f = userdata.string(forColumn: "a_id")
            
            let sam = d?.components(separatedBy: "_")
            
            
            images.append(x!)
            content.append(z!)
            tittle.append(y!)
            date.append(a!)
            likeStatus.append(b!)
            knowMore.append(sam![1])
            likeCount.append(sam![0])
            tag.append(e!)
            id.append(f!)
            knowMoreUrl.append(c!)
            
    self.newsArticleTableView.reloadData()
    }
  

}
    func pressed(sender: UIButton!) {
        
        let buttonindex =  sender.tag
        if (sender.isSelected){
            print("unselected")
            
            DataBaseManager.shared.ExecuteCommand(query: "UPDATE NewsArticle SET like_status = 0 WHERE a_id=\(id[buttonindex]);")
            loadData()
            sender.isSelected = false
        }
        else{
            print("selected")
            print(buttonindex)
            DataBaseManager.shared.ExecuteCommand(query: "UPDATE NewsArticle SET like_status = 1 WHERE a_id=\(id[buttonindex]);")
            print(id[buttonindex])
            loadData()
            sender.isSelected = true
        }
    }
    func share(sender: UIButton!){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = view.screenshot
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out my app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
          //  let objectsToShare = [image]
            let activityVC = UIActivityViewController(activityItems: [image,myWebsite,textToShare], applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList,UIActivityType.message,UIActivityType.mail,UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.openInIBooks,UIActivityType.saveToCameraRoll]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func knowMore(sender: UIButton!){
    let buttonindex =  sender.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"secondViewController") as! KnowMoreViewController
        viewController.urlstring = knowMoreUrl[buttonindex]
        self.present(viewController, animated: true)
    
    
    }
    
    @IBAction func callBtn(_ sender: Any) {
        let myalert = UIAlertController(title: "Call", message: "Do u want to call", preferredStyle: UIAlertControllerStyle.alert )
        
        let noaction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
      let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.callNumber(phoneNumber: "9567019109")
        }
        myalert.addAction(noaction)
        myalert.addAction(yesAction)
        self.present(myalert, animated: true, completion: nil)
        

        
    }
    func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}
extension UIView{
    
    var screenshot: UIImage{
        
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}
