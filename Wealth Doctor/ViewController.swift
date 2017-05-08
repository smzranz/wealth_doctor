//
//  ViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 26/02/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var loadFavorited : Bool = false
    
    @IBOutlet weak var favoritedToolTip: PaddingLabel!
    @IBOutlet var refreshBtnOulet: UIBarButtonItem!
    let mobileNumber = UserDefaults.standard.value(forKey: "mobileverified")
    var lastIndexPath: Int = 0
    let row = UserDefaults.standard.integer(forKey: "row")
    let section = UserDefaults.standard.integer(forKey: "section")
    var scrollToUnreadNews : Bool = false
    @IBOutlet var newNewsBtn: UIButton!
    
    var refresher : UIRefreshControl!
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
    var favorited = [String]()
    var tagId = [String]()
    var artTime = "old"
    var tagSelected = ""
    var tagIsClicked:Bool = false
    var gotoTopActive : Bool = false
    var gamer : Timer!
    @IBOutlet var newsArticleTableView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   print(lastIndexPath)
       // navigationController?.navigationBar.isHidden = true
         navigationController?.hidesBarsOnSwipe = true
        favoritedToolTip.isHidden = true
        favoritedToolTip.layer.cornerRadius = 8
        favoritedToolTip.layer.masksToBounds = true
        newNewsBtn.isHidden = true
        gamer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        newNewsBtn.layer.cornerRadius = newNewsBtn.frame.height/2
        refresher  = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    newsArticleTableView.addSubview(refresher)
     //   navigationController?.navigationBar.isHidden = false
        if tagIsClicked == false{
        if UserDefaults.standard.value(forKey: "first") != nil{
         loadData()
            
           
        }
        else {
            
            articleLoad(arttime: "NEW", tag_id: "")
        }
        }
        else{
        
        tagClick(mobile: "", arttime: "NEW", tag_id: tagSelected)
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//            // Sets shadow (line below the bar) to a blank image
//            UINavigationBar.appearance().shadowImage = UIImage()
//            // Sets the translucent background color
//            UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
//            // Set translucent. (Default value is already true, so this can be removed if desired.)
//            UINavigationBar.appearance().isTranslucent = true
        
    }
    
    override func viewDidLayoutSubviews() {
        if scrollToUnreadNews == true{
        newsArticleTableView.scrollToItem(at: [section,row], at: .bottom, animated: false)
        
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
        
        cell.askBtn.setImage(#imageLiteral(resourceName: "hs_ask"), for: .normal)
        if row < indexPath.row{
            let defaults = UserDefaults.standard
            defaults.set(indexPath.row, forKey: "row")
            defaults.set(indexPath.section, forKey: "section")
            //  UserDefaults.standard.setValue(indexPath, forKey: "indexPath")
            UserDefaults.standard.synchronize()
        }
        
        
      //  lastIndexPath = indexPath
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
        if favorited[indexPath.row] == "0"{
            
            cell.favoriteBtn.isSelected = false
            
        }
        else {
            cell.favoriteBtn.isSelected = true
        }
        cell.favoriteBtn.titleLabel?.textAlignment = .left
       // cell.askBtn.addTarget(self, action: #selector(ask(sender:)), for: .touchUpInside)
        cell.askBtn.tag = indexPath.row
        cell.knowMorebtn.addTarget(self, action: #selector(knowMore(sender:)), for: .touchUpInside)
        cell.knowMorebtn.tag = indexPath.row
        cell.knowMorebtn.setTitle(knowMore[indexPath.row], for: .normal)
        cell.favoriteBtn.addTarget(self, action:  #selector(favorited(sender:)), for: .touchUpInside)
        
        cell.favoriteBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        cell.likeBtn.layer.cornerRadius = cell.likeBtn.frame.height/2
        cell.likeBtn.layer.borderColor = UIColor(colorLiteralRed: 28/255, green: 126/255, blue: 211/255, alpha: 1.0).cgColor
        cell.likeBtn.layer.borderWidth = 1
        cell.likeBtn.layer.masksToBounds = true
         cell.likeBtn.tag = indexPath.row
        cell.favoriteBtn.setTitle(tittle[indexPath.row], for: .normal)
          cell.favoriteBtn.setTitle(tittle[indexPath.row], for: .selected)
        cell.favoriteBtn.setTitleColor(UIColor.black, for: .normal)
        cell.favoriteBtn.setTitleColor(UIColor(colorLiteralRed: 28/255, green: 126/255, blue: 211/255, alpha: 1.0), for: .selected)
        
        cell.likeBtn.isUserInteractionEnabled = true
        cell.likeBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        cell.likeBtn.setImage(#imageLiteral(resourceName: "like_second"), for: .selected)
//cell.newsImage.sd_setImage(with: URL(string: remoteImageUrlString), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        cell.newsImage.sd_setImage(with: URL(string: remoteImageUrlString), placeholderImage: #imageLiteral(resourceName: "place_holder"), options: SDWebImageOptions.progressiveDownload, completed: block)
        
        
      //  cell.tittleLabel.text = tittle[indexPath.row]
      //  cell.knowMorebtn.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        cell.shareBtn.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        cell.newsContentLabel.text = content[indexPath.row]
        if likeCount.count>0{
        cell.likesCountLabel.text = "\(likeCount[indexPath.row]) Likes"
            
            
            if indexPath.row == images.count-1{
            
            self.articleLoad(arttime: "old", tag_id: "")
            
            }
            if indexPath.row > 3 {
            
            refreshBtnOulet.image = #imageLiteral(resourceName: "goto_top")
                //setBackgroundImage(#imageLiteral(resourceName: "goto_top"), for: .normal, barMetrics: .default)
            gotoTopActive = true
            }
            else{
              refreshBtnOulet.image = #imageLiteral(resourceName: "refresh")
            gotoTopActive = false
            }
     //   cell.knowMorebtn.setTitle("\(knowMore[indexPath.row])", for: .normal)
        }
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
        
        let postString = "mobile=\(mobileNumber as! String)&art_time=\(arttime)&tag_id=\(tag_id)"
        request.httpBody = postString.data(using: .utf8)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let responseString = String(data: data!, encoding: .utf8){
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
                                    let news_paper = news["news_paper"]as! String
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
                                    let like_count = news["like_count"]
                                    
                                    let n_date = news["n_date"] as! String
                                   // let like_status = news["like_status"] as! String
                                     DataBaseManager.shared.ExecuteCommand(query: "insert into NewsArticle (a_audio_url , a_content , a_content_sort ,a_id , a_image , a_tag ,a_title ,a_video_url ,like_count ,like_status ,n_date ,no_more_url,tag_id,favorited,newspaper)values ( '\(0)', '\(a_content)', '\(0)','\(a_id)','\(a_image)', '\(a_tag)','\(a_title)','\(0)','\(like_count!)',0,'\(n_date)','\(no_more_url)','\(tag_id)','\(0)','\(news_paper)');")
                                    
                                }
                            }

                        }
                        
                        DispatchQueue.main.async {
                           self.loadData()
                           UserDefaults.standard.setValue("first", forKey: "first")
                            self.refresher.endRefreshing()
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    
                }
            }
        }
            else{}
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
        favorited = [String]()
        
        if loadFavorited == true{
        
            let userdata = DataBaseManager.shared.fetchData(Query: "select * from NewsArticle where favorited = 1 ;")
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
                let g = userdata.string(forColumn: "newspaper")
                let h = userdata.string(forColumn: "favorited")
                //    let sam = d?.components(separatedBy: "_")
                
                
                images.append(x!)
                content.append(z!)
                tittle.append(y!)
                date.append(a!)
                likeStatus.append(b!)
                knowMore.append(g!)
                likeCount.append(d!)
                tag.append(e!)
                id.append(f!)
                knowMoreUrl.append(c!)
                favorited.append(h!)
                
                self.newsArticleTableView.reloadData()
            }
        
        userdata.close()
        }
        else{
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
            let g = userdata.string(forColumn: "newspaper")
            let h = userdata.string(forColumn: "favorited")
        //    let sam = d?.components(separatedBy: "_")
            
            
            images.append(x!)
            content.append(z!)
            tittle.append(y!)
            date.append(a!)
            likeStatus.append(b!)
            knowMore.append(g!)
            likeCount.append(d!)
            tag.append(e!)
            id.append(f!)
            knowMoreUrl.append(c!)
            favorited.append(h!)
            
    self.newsArticleTableView.reloadData()
    }
            userdata.close()
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
    
    
    func favorited(sender: UIButton!){
        let buttonindex =  sender.tag
        if (sender.isSelected){
            print("unselected")
            favoritedToolTip.text = "Removed from favourites"
            favoritedToolTip.isHidden = false
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
            DataBaseManager.shared.ExecuteCommand(query: "UPDATE NewsArticle SET favorited = 0 WHERE a_id=\(id[buttonindex]);")
           loadData()
            sender.isSelected = false
        }
        else{
            print("selected")
            
            favoritedToolTip.text = "Added to favourites"
            favoritedToolTip.isHidden = false
                    Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
           // print(buttonindex)
            DataBaseManager.shared.ExecuteCommand(query: "UPDATE NewsArticle SET favorited = 1 WHERE a_id=\(id[buttonindex]);")
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
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
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
       // self.present(viewController, animated: true)
        self.showAnimationRightToLeft()
        self.navigationController?.pushViewController(viewController, animated: false)
    
    
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
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func tagClick(mobile:String, arttime:String,tag_id:String){
        
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
        favorited = [String]()
        let scriptUrl = "http://www.indianmoney.com/wealthDoctor/ios/wd_articles.php"
        
        let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
        
        let myUrl = URL(string: urlWithParams);
        
        var request = URLRequest(url:myUrl!)
        
        let postString = "mobile=\(mobileNumber as! String)&art_time=\(arttime)&tag_id=\(tag_id)"
        request.httpBody = postString.data(using: .utf8)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let responseString = String(data: data!, encoding: .utf8){
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
                                    
                                    
                                        let news_paper = news["news_paper"]as! String
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
                                    
                                        
                                    

                                    
                                    self.images.append(a_image)
                                    self.content.append(a_content)
                                    self.tittle.append(a_title)
                                    self.date.append(n_date)
                                  //  self.likeStatus.append(b!)
                                       self.knowMore.append(news_paper)
                                    self.likeCount.append(like_count)
                                    self.tag.append(a_tag)
                                    self.id.append(no_more_url)
                                    self.knowMoreUrl.append(a_id)
                                    self.likeStatus.append("0")
                                    self.favorited.append("0")
                                    
                                    
                                }
                              self.newsArticleTableView.reloadData()  
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.newsArticleTableView.reloadData()
                            //  self.performSegue(withIdentifier: "mobiletootp", sender: self)
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    
                }
            }
        }
            else{
                DispatchQueue.main.async {
                    //  self.displaymyalertmessage(usermessage: "serverdown")
                }
                
            }
        }
       
        task.resume()
        
    }
    
    func refresh(){
    DataBaseManager.shared.ExecuteCommand(query: "DELETE FROM NewsArticle;")
    articleLoad(arttime: "NEW", tag_id: "")
        
    }
    
  
    @IBAction func refreshBtnAction(_ sender: Any) {
        
        if gotoTopActive == true{
            self.newsArticleTableView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                              animated: true)
    //    scrollViewDidScrollToTop(newsArticleTableView)
        }else{
        refresh()
        }
        
    }
    
    @IBAction func newNewsClick(_ sender: Any) {
        
        newNewsBtn.isHidden = true
    }
    func runTimedCode() {
        newNewsBtn.isHidden = true
        
        
    }
    
    func showAnimationLeftToRight() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    func showAnimationRightToLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MenuViewController") as! MenuViewController
       showAnimationLeftToRight()
        self.navigationController?.pushViewController(viewController, animated: false)
     //   self.present(viewController, animated: false)
        
    }
    func update() {
    
    favoritedToolTip.isHidden = true
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
