//
//  PeopleCollectionViewCell.swift
//  InRatingTest
//
//  Created by Данил on 11/28/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit
import Alamofire

class PeopleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(at indexPath: IndexPath, collectionViewNumber: Int) {
        nameLabel.text = People.peoples[collectionViewNumber][indexPath.row].name
        Alamofire.request(People.peoples[collectionViewNumber][indexPath.row].avatar).response { response in
            self.avatarImage.image = UIImage(data: response.data!)
        }
    }
}
