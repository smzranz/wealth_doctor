//
//  TableCreateViewController.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 04/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class TableCreateViewController: UIViewController {
    let slno = "slno"
    let state_ID = "stateID"
    let state_Name = "stateNAME"
    let city_Name = "cityNAME"
    let city_ID = "cityID"
    let user_Chat = "userChat"
    let server_Chat = "serverChat"
      override func viewDidLoad() {
        super.viewDidLoad()

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func creatingStateTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table STATES (\(slno) integer primary key autoincrement not null, \(state_ID) text not null, \(state_Name) text not null)")
        if result == true {
            
            print("state table created succesfully")
        }
    }
    func creatingCityTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table CITIES (\(slno) integer primary key autoincrement not null, \(state_ID) text not null, \(city_ID) text not null, \(city_Name) text not null)")
        if result == true {
            
            print("cities table created succesfully")
        }
    }
    
    func creatingChatTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table CHAT (\(slno) integer primary key autoincrement not null, type text not null, \(server_Chat) text not null, ans_id text not null ,url text not null, product_id text not null , disable text not null,chat_id text not null,time text not null)")
        if result == true {
            
            print("chat table created succesfully")
        }
    }
    func creatingNewsArticleTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table NewsArticle (\(slno) integer primary key autoincrement not null, a_audio_url text not null, a_content text not null, a_content_sort text not null ,a_id text not null, a_image text not null , a_tag text not null,a_title text not null,a_video_url text not null,like_count integer not null,like_status text not null,n_date text not null,no_more_url text not null,tag_id text not null,favorited text not null,newspaper text not null)")
        if result == true {
            
            print("NewsArticle table created succesfully")
        }
    }
    func creatingTagsTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table tags (\(slno) integer primary key autoincrement not null, advice text not null, advice_id text not null)")
        if result == true {
            
            print("tags table created succesfully")
        }
    }
    func creatingQuestionsTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table questions (\(slno) integer primary key autoincrement not null, q_choice text not null, q_choice_id text not null)")
        if result == true {
            
            print("Questions table created succesfully")
        }
    }
    func creatingUserTagTable(){
        
        var result = Bool()
        
        result = DataBaseManager.shared.ExecuteQuery(query: "create table USERTAGS (\(slno) integer primary key autoincrement not null, tag_id text not null, tag_name text not null)")
        if result == true {
            
            print("User Tags table created succesfully")
        }
    }


}
