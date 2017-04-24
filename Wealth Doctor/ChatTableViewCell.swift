//
//  ChatTableViewCell.swift
//  Wealth Doctor
//
//  Created by Shamshir Anees on 05/03/17.
//  Copyright © 2017 indianmoney.com. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var tagCollectionView: UICollectionView!
    @IBOutlet var serverChatTime: UILabel!
    @IBOutlet var userChatTime: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var userChatLabel: UILabel!
    @IBOutlet var serverChatLabel: UILabel!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  // tagCollectionView.collectionViewLayout = UICollectionViewFlowLayout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
