//
//  NewsArticlesCollectionViewCell.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 11/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class NewsArticlesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var newsImage: UIImageView!
    
    @IBOutlet var favoriteBtn: UIButton!
    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var newsContentLabel: UILabel!
    
    @IBOutlet var knowMorebtn: UIButton!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var shareBtn: UIButton!
    
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var gdpLabel: UILabel!
    @IBOutlet var askBtn: UIButton!
}
