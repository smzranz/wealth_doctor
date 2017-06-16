//
//  ViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 26/02/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import UserNotifications

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var loadFavorited : Bool = false
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var newNewsClicked : Bool = false
    
    @IBOutlet weak var bottomWishLabel: UILabel!
    @IBOutlet weak var mesageLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var greetingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var wishLabel: UILabel!
    @IBOutlet weak var greetingView: UIView!
    @IBOutlet weak var morngBgView: UIView!
    
    @IBOutlet weak var titleName: UIBarButtonItem!
    @IBOutlet weak var favoritedToolTip: PaddingLabel!
    @IBOutlet var refreshBtnOulet: UIBarButtonItem!
    
    
    
     let name = UserDefaults.standard.value(forKey: "Name")
    let mobileNumber = UserDefaults.standard.value(forKey: "mobileverified")
    var lastIndexPath: Int = 0
    let row = UserDefaults.standard.integer(forKey: "row")
    let section = UserDefaults.standard.integer(forKey: "section")
    var scrollToUnreadNews : Bool = false
    var fromUnread = 0
    @IBOutlet var newNewsBtn: UIButton!
   // var tagEnabled : Bool = false
    let dateComponentsFormatter = DateComponentsFormatter()

    var tagForTitle = ""
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
    let application = UIApplication.shared
    @IBOutlet var newsArticleTableView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsArticleTableView.delegate = self
        newsArticleTableView.dataSource = self

        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow,error in
        })
        
        let parameters = ["mobile number":mobileNumber as! String]
        Flurry.logEvent("Started to Read Articles", withParameters: parameters,timed:true);
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))
     //   print(lastIndexPath)
       // navigationController?.navigationBar.isHidden = true
         navigationController?.hidesBarsOnSwipe = true
        favoritedToolTip.isHidden = true
        favoritedToolTip.layer.cornerRadius = 8
        favoritedToolTip.layer.masksToBounds = true
      //  newNewsBtn.isHidden = true
        gamer = Timer.scheduledTimer(timeInterval: 60*2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
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
        
        if UserDefaults.standard.value(forKey: "date") == nil{
            
            self.morngBgView.isHidden = true
            self.newNewsBtn.isHidden = true
            UserDefaults.standard.set(Date(), forKey: "date")
        }else{
           
            let yourDate = UserDefaults.standard.object(forKey: "date") as? Date
            let day = Calendar.current.component(.day, from: yourDate!)
            
            let today = Calendar.current.component(.day, from: Date())
            
            if Calendar.current.component(.hour, from: yourDate!) != Calendar.current.component(.hour, from: Date()){
                localNotification()
                UserDefaults.standard.set(Date(), forKey: "date")
                
            }
            else{}
            if day != today{
                greetings(mobile: mobileNumber as! String, last_id: id[id.count-1], first_id: id[0], daily_report: "1", getNewPosts: false)
                
                UserDefaults.standard.set(Date(), forKey: "date")
            }
            else{
               
                if UserDefaults.standard.object(forKey: "newNewsClicked") as? Bool ==  true{
                self.newNewsBtn.isHidden = true
                }else if UserDefaults.standard.object(forKey: "newNewsClicked") as? Bool ==  true{
                
                self.newNewsBtn.isHidden = false
                }else{
                self.newNewsBtn.isHidden = true
                }
                self.morngBgView.isHidden = true
               
            }
            
        }

        if loadFavorited == true{
            self.titleName.title = "Favorites"
//self.navigationItem.title = "Favorites"
            
        }  else{
            
            if tagIsClicked == true{
                 self.titleName.title = "\(tagForTitle)"
              //  self.navigationItem.title = "\(tagForTitle)"
            }else if fromUnread == 1{
            
            self.titleName.title = "Unread"
            }
                
                
            else{
                 self.titleName.title = "Main Stream"
       //   self.navigationItem.title = "Main Stream"
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
        
        
            }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
        Flurry.endTimedEvent("Started to Read Articles", withParameters: nil)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        
////            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
////            // Sets shadow (line below the bar) to a blank image
////            UINavigationBar.appearance().shadowImage = UIImage()
////            // Sets the translucent background color
////            UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
////            // Set translucent. (Default value is already true, so this can be removed if desired.)
////            UINavigationBar.appearance().isTranslucent = true
//        
//    }
    
    override func viewDidLayoutSubviews() {
        if scrollToUnreadNews == true{
        newsArticleTableView.scrollToItem(at: [section,row], at: .bottom, animated: false)
        scrollToUnreadNews = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//       
//                if UserDefaults.standard.object(forKey:"tutorialView") != nil{
//                                // showGuides()
//                            }else{
//                    
//                                self.showGuides()
//                                UserDefaults.standard.set("tutorialView", forKey: "tutorialView")
//                                
//                            }
//            
//        
//    
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsArticlesCollectionViewCell
        
        if indexPath.row == 0{
            if UserDefaults.standard.object(forKey:"tutorialView") != nil{
                // showGuides()
            }else{
                
                KSGuideDataManager.reset(for: "MainGuide")
                
                var items = [KSGuideItem]()
                items.append(KSGuideItem(sourceView: cell.favoriteBtn, text: "Click to favorite the Article"))
                
                items.append(KSGuideItem(sourceView: cell.shareBtn, text: "Share the Article"))
                
                if tag[0] == "0" {
                }else{
                items.append(KSGuideItem(sourceView: cell.tagBtn, text: "Ask us About Tag"))
                }
                items.append(KSGuideItem(sourceView: cell.knowMorebtn, text: "Click to Know more about the Article"))
                items.append(KSGuideItem(sourceView:cell.askBtn , text: "Chat with our Siri"))
                items.append(KSGuideItem(sourceView: cell.likeBtn, text: "Like the Article"))
                let vc = KSGuideController(items: items, key: "MainGuide")
                vc.setIndexChangeBlock { (index, item) in
                    print("Index has change to \(index)")
                }
                vc.show(from: self) {
                    print("Guide controller has been dismissed")
                }

                UserDefaults.standard.set("tutorialView", forKey: "tutorialView")
                
            }

        
        
        }
        
        
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
            
            
            
          //  print("Image with url \(remoteImageUrlString) is loaded")
            
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
        
        
        if tittle[indexPath.row] == "share"{
            
            cell.newsImage.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height-80)
            
        }
        else{
            
            cell.newsImage.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
        }    
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
        cell.tagBtn.layer.cornerRadius = 10
            cell.tagBtn.layer.borderColor = UIColor.lightGray.cgColor
            cell.tagBtn.layer.borderWidth = 1
            cell.tagBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.tagBtn.tintColor = ColorFile().getMarkerDarkAshColor()
           cell.tagBtn.addTarget(self, action: #selector(tagPressed(sender:)), for: .touchUpInside)
            cell.tagBtn.tag = indexPath.row
            cell.gdpLabel.text = "\(date[indexPath.row]) Ago"
            if tag[indexPath.row] == "0"{
            cell.tagBtn.isHidden = true
            
            }else{
            cell.tagBtn.isHidden = false
             cell.tagBtn.setTitle("  \(tag[indexPath.row])  ", for: .normal)
            }
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
    
    
        let scriptUrl = "https://www.indianmoney.com/wealthDoctor/ios/wd_articles.php"
        
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
                                  //  dd MMM yyyy
                                    // 2017-03-30 10:30:11
                                    //        2017-05-11 09:13:44 +0000
                                    let n_date = news["n_date"] as! String
                                   // let dateString = "2017-03-30 10:30:11"
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    dateFormatter.locale = Locale.init(identifier: "en_IN")
                                    
                                    let dateObj = dateFormatter.date(from: n_date)
                                    
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    print("Dateobj: \(dateFormatter.string(from: dateObj!))")
                                    let now = Date()
                                    let timeOffset3 = now.offset(from: dateObj!)
                                    print(timeOffset3)
                                    
                                    var tag = ""
                                    if a_tag == ""{
                                    
                                    tag = "0"
                                    }else{
                                    tag = a_tag
                                    }
                                    var mainTittle = ""
                                    if a_title == ""{
                                        
                                        mainTittle = "0"
                                    }else{
                                        mainTittle = a_title
                                    }
                                   // let like_status = news["like_status"] as! String
                                     DataBaseManager.shared.ExecuteCommand(query: "insert into NewsArticle (a_audio_url , a_content , a_content_sort ,a_id , a_image , a_tag ,a_title ,a_video_url ,like_count ,like_status ,n_date ,no_more_url,tag_id,favorited,newspaper)values ( '\(0)', '\(a_content)', '\(0)','\(a_id)','\(a_image)', '\(tag)','\(mainTittle)','\(0)','\(like_count!)',0,'\(timeOffset3)','\(no_more_url)','\(tag_id)','\(0)','\(news_paper)');")
                                    
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
        var userdata = FMResultSet()
        if loadFavorited == true{
        
             userdata = DataBaseManager.shared.fetchData(Query: "select * from NewsArticle where favorited = 1 ;")
            
        }  else{
            
            if tagIsClicked == true{
            
            userdata = DataBaseManager.shared.fetchData(Query: "select * from NewsArticle where tag_id = '\(tagSelected)' ;")
            }
            else{
         userdata = DataBaseManager.shared.fetchData(Query: "select * from NewsArticle ;")
            }
            }
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
   
    }
         self.newsArticleTableView.reloadData()
       // print(date)
            userdata.close()
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
            Flurry.logEvent("Favorited", withParameters: ["Article Headline":"\(tittle[buttonindex])"]);
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
        
        if let myWebsite = URL(string: "https://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
          //  let objectsToShare = [image]
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList,UIActivityType.message,UIActivityType.mail,UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.openInIBooks,UIActivityType.saveToCameraRoll]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func tagPressed(sender: UIButton!){
    
        let buttonindex =  sender.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"chatViewController") as! ChatViewController
        
        viewController.isTagPressed = true
        viewController.selectedTagFromNews = tag[buttonindex]
       // viewController.urlstring = knowMoreUrl[buttonindex]
        // self.present(viewController, animated: true)
        self.showAnimationRightToLeft()
        self.navigationController?.pushViewController(viewController, animated: false)

    
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
        let scriptUrl = "https://www.indianmoney.com/wealthDoctor/ios/wd_articles.php"
        
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
                                        // let dateString = "2017-03-30 10:30:11"
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                        dateFormatter.locale = Locale.init(identifier: "en_IN")
                                        
                                        let dateObj = dateFormatter.date(from: n_date)
                                        
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
                                        let now = Date()
                                        let timeOffset3 = now.offset(from: dateObj!)
                                        print(timeOffset3)
                                        
                                        var tag = ""
                                        if a_tag == ""{
                                            
                                            tag = "0"
                                        }else{
                                            tag = a_tag
                                        }
                                        var mainTittle = ""
                                        if a_title == ""{
                                            
                                            mainTittle = "0"
                                        }else{
                                            mainTittle = a_title
                                        }
                                        // let like_status = news["like_status"] as! String
                                        DataBaseManager.shared.ExecuteCommand(query: "insert into NewsArticle (a_audio_url , a_content , a_content_sort ,a_id , a_image , a_tag ,a_title ,a_video_url ,like_count ,like_status ,n_date ,no_more_url,tag_id,favorited,newspaper)values ( '\(0)', '\(a_content)', '\(0)','\(a_id)','\(a_image)', '\(tag)','\(mainTittle)','\(0)','\(like_count!)',0,'\(timeOffset3)','\(no_more_url)','\(tag_id)','\(0)','\(news_paper)');")
                                        
                                    }
                                }
                                
                            }
                            
                            DispatchQueue.main.async {
                                self.loadData()
                              //  UserDefaults.standard.setValue("first", forKey: "first")
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
    
    func refresh(){
    DataBaseManager.shared.ExecuteCommand(query: "DELETE FROM NewsArticle;")
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "row")
        defaults.set(0, forKey: "section")
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
        newNewsClicked =  true
        UserDefaults.standard.set(newNewsClicked, forKey: "newNewsClicked")
         refresh()
        newNewsBtn.isHidden = true
    }
    func runTimedCode() {
        greetings(mobile: mobileNumber as! String, last_id: id[id.count-1], first_id: id[0], daily_report: "1", getNewPosts: true)
        
        
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
        if fromUnread == 1{
        viewController.sideSelected = 2
        }else if loadFavorited == true{
            viewController.sideSelected = 3
        }
        else{
        viewController.sideSelected = 1
        }
       showAnimationLeftToRight()
        self.navigationController?.pushViewController(viewController, animated: false)
     //   self.present(viewController, animated: false)
        
    }
    func update() {
    
    favoritedToolTip.isHidden = true
        
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        self.morngBgView.isHidden = true
       
        
    }
    
    func greetings(mobile:String,last_id:String,first_id:String,daily_report:String,getNewPosts:Bool){
        
        let networkStatus = Reeachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            displaymyalertmessage(usermessage: "no internet connection")
            print("no internet connection")
        default :
          //  actstart()
            let scriptUrl = "https://www.indianmoney.com/wealthDoctor/ios/newnewscount.php"
            
            let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
            
            let myUrl = URL(string: urlWithParams);
            
            var request = URLRequest(url:myUrl!)
            
            let postString = "mobile=\(mobile)&last_id=\(last_id)&first_id=\(first_id)&daily_report=\(daily_report)"
            request.httpBody = postString.data(using: .utf8)
            
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                                   // print("responseString = \(responseString)")
                   
                    if error != nil
                    {
                        print("error=\(error)")
                        DispatchQueue.main.async {
                            
                        }
                        return
                    }
                if let responseString = String(data: data!, encoding: .utf8){

                    if responseString == "null\n"{
                        
                    }
                    else{
                        
                        do {
                            
                            if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]    {
                                //   print(convertedJsonIntoArray)
                                
                              let count = convertedJsonIntoArray["count"] as! String
                                let app_version = convertedJsonIntoArray["app_version"] as! String
                                let greetings = convertedJsonIntoArray["greetings"] as! String
                                let Message = convertedJsonIntoArray["Message"] as! String
                                let wish = convertedJsonIntoArray["wish"] as! String
                                let imgurl = convertedJsonIntoArray["imgurl"] as! String
                                
                                    
                                    
                                    
                                    
                                    
                                    //
                                    //  print(nestedDictionary)
                                
                                
                               // self.actstop()
                                
                                
                                
                                
                                DispatchQueue.main.async {
                                    self.wishLabel.attributedText =  self.stringFromHtml(string: greetings)
                                    self.greetingImageView.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "placeHolder"))
                                    
                                    self.newNewsBtn.setTitle("+\(count) news", for: .normal)
                                    self.bottomWishLabel.text = wish
                                    self.mesageLabel.attributedText = self.stringFromHtml(string: Message)
                                    UserDefaults.standard.set(false, forKey: "newNewsClicked")
                                    if getNewPosts == true{
                                        self.morngBgView.isHidden = true
                                        self.newNewsBtn.isHidden = false
                                    }else{
                                     self.morngBgView.isHidden = false
                                    self.newNewsBtn.isHidden = false
                                    }
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
                        //   self.displaymyalertmessage(usermessage: "serverdown")
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
    
    
        func stringFromHtml(string: String) -> NSAttributedString? {
            do {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
                if let d = data {
                    let str = try NSAttributedString(data: d,
                                                     options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                     documentAttributes: nil)
                    return str
                }
            } catch {
            }
            return nil
        }
    
    func localNotification(){
        let url = URL(string: "https://www.indianmoney.com/wealthDoctor/flatfiles/resendNews.json")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    if let nestedString = json["article_details"] as? [String:Any]{
                        
                        
                        if let newsArray = nestedString["news"] as? NSArray {
                            
                            let news = newsArray[0] as! [String:Any]
                            
                            
                            let a_title = news["a_title"] as! String
                            let a_content = news["a_content"] as! String
                            
                            let a_image = news["a_image"] as! String
                            
                            
                            
                            
                            
                            
                            
                            
                            OperationQueue.main.addOperation({
                                
                                let content = UNMutableNotificationContent()
                                content.title = a_title
                                content.body = a_content
                                let application = UIApplication.shared
                                application.applicationIconBadgeNumber = 1
                                // content.launchImageName = "image.jpg"
                                content.badge = application.applicationIconBadgeNumber as NSNumber
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                                let imageView1 = UIImageView()
//                                
//                                imageView1.sd_setImage(with: URL(string: a_image), placeholderImage: UIImage(named: "placeHolder"))
//                                
//                                if let image = imageView1.image {
//                                    if let data = UIImagePNGRepresentation(image) {
//                                        let filename = self.getDocumentsDirectory().appendingPathComponent("copy.png")
//                                        try? data.write(to: filename)
//                                    }
//                                }
//                                let sam = "\(self.getDocumentsDirectory())/copy.png"
//                                let fileURL : URL = URL(string: sam)!
//                                
//                                let attachement = try? UNNotificationAttachment(identifier: "attachment", url: fileURL, options: nil)
//                                content.attachments = [attachement!]
                                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                
                                
                                
                            })
                        }
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func showGuides() {
        // Reset to show everytime.
        KSGuideDataManager.reset(for: "MainGuide")
        
        var items = [KSGuideItem]()
//        for button in buttons {
//            //            let n = Int(arc4random()) % string.characters.count
//            //            let index = string.index(string.startIndex, offsetBy: Int(n))
//            let text = string[buttons.index(of: button)!]
//            let item = KSGuideItem(sourceView: button, text: text)
//            items.append(item)
//        }
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = newsArticleTableView.cellForItem(at: indexPath) as! NewsArticlesCollectionViewCell
        
        
        
        items.append(KSGuideItem(sourceView: cell.favoriteBtn, text: "Click to favorite the Article"))
        
        items.append(KSGuideItem(sourceView: cell.shareBtn, text: "Share the Article"))
       // if
        items.append(KSGuideItem(sourceView: cell.tagBtn, text: "Ask us About Tag"))
        items.append(KSGuideItem(sourceView: cell.knowMorebtn, text: "Click to Know more about the Article"))
        items.append(KSGuideItem(sourceView:cell.askBtn , text: "Chat with our Siri"))
        items.append(KSGuideItem(sourceView: cell.likeBtn, text: "Like the Article"))
        let vc = KSGuideController(items: items, key: "MainGuide")
        vc.setIndexChangeBlock { (index, item) in
            print("Index has change to \(index)")
        }
        vc.show(from: self) {
            print("Guide controller has been dismissed")
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
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) Year"   }
        if months(from: date)  > 0 { return "\(months(from: date)) Month"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) Week"   }
        if days(from: date)    > 0 { return "\(days(from: date)) Day"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) Hour"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) Mins" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) Seconds" }
        return ""
    }
    
    
}
extension String {
    
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
