//
//  StatisticsTableViewController.swift
//  InRatingTest
//
//  Created by Данил on 11/28/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Usage: Int {
    case obtainID = 0
    case obtainLikers = 1
    case obtainCommenters = 2
    case obtainMentioned = 3
    case obtainReposters = 4
}

class StatisticsTableViewController: UITableViewController {
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var repostsCollectionView: UICollectionView!
    
    @IBOutlet weak var bookmarksLabel: UILabel!
    
    let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjJmNGU5ZDA1MzU3MDI3MmFlMGZhZTMzM2Y4ZTY4ZWVlMWNiMzc0NmM0Mjg5NzI0ZTExNzJjM2Q4ODYzNDNkNDkyY2ZjZjI4Njg0NzQ0MGEwIn0.eyJhdWQiOiIyIiwianRpIjoiMmY0ZTlkMDUzNTcwMjcyYWUwZmFlMzMzZjhlNjhlZWUxY2IzNzQ2YzQyODk3MjRlMTE3MmMzZDg4NjM0M2Q0OTJjZmNmMjg2ODQ3NDQwYTAiLCJpYXQiOjE1MzY4MzE4ODcsIm5iZiI6MTUzNjgzMTg4NywiZXhwIjoxNTY4MzY3ODg3LCJzdWIiOiIzOCIsInNjb3BlcyI6W119.dRitRnoqNFS3xUgtLdLiDjDVVe7ZFNrh24Qm2ML9m-V7kZpgQgajArYoS44kMa1dz_MHUhq3pqk8SnAYIsULgfrOvewTUzmH1C92-yL64Uqnv7lqWizldX2fbJ2IbB8khOCtQ-CCNA_fGY_zEBJXLsOqr4Z00tbZE6fa0PX4Mu0SsuUakLeygXbXnKOmFyZmLJZWoXKpbqiSBU239nrcyqJftBon8DL1BAUuFiadap-gpVSXj8h6BX-FsJx5cgPHFiijIalcEgzOq4VCMkwbQE8xbTsmmxkZUOnM7oKab5inzl8EV5iUgcExeSbHT6k_phOkA7XUaR6PhVoKrSQTPcfdijhME1IHfPVDPGO0vhd6hKszRrhjEPEpoothBoB8ss0lmuCFURdxFv17q97rfpDn1OfO_Y3wYuRW2lqFAnw7sLd92CHjfONwQKswLDzwE4hiQhB8iS_UEbuL_UamNOiCLfjNnVWbVc9BvoReEa8jG4coc0Kv9VNJVWh3D_hGf8dLRZBd1a7zB6-nSpKGf0eAzB0_rBXsyBepjudC-5EFDjloJOxy1Mdruoq6mQa_tFcO99JRteUSd0CXHZO-CN4Bp4xND9kstdutjBn2UWT5xhNq_QRBmBsBDAwp647dUCyQofutN9GUlu2LxmhL0ojydazdND_d9rHtY9t-ndw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesCollectionView.delegate = self
        commentsCollectionView.delegate = self
        peopleCollectionView.delegate = self
        repostsCollectionView.delegate = self
        
        likesCollectionView.dataSource = self
        commentsCollectionView.dataSource = self
        peopleCollectionView.dataSource = self
        repostsCollectionView.dataSource = self
        
        likesCollectionView.register(UINib.init(nibName: "PeopleCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PeopleCell")
        peopleCollectionView.register(UINib.init(nibName: "PeopleCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "PeopleCell")
        commentsCollectionView.register(UINib.init(nibName: "PeopleCollectionViewCell", bundle: nil),
                                        forCellWithReuseIdentifier: "PeopleCell")
        repostsCollectionView.register(UINib.init(nibName: "PeopleCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "PeopleCell")
        
        getInformation(with: "https://api.inrating.top/v1/users/posts/get",
                       parameters: ["slug" : "q3ACx3fRsFOe"], usage: .obtainID)
    }
    
    func getInformation(with url: String, parameters: [String: String]?, usage: Usage) {
        
        let header = ["Authorization": "Bearer \(accessToken)"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) in
            if response.result.isSuccess {
                
                let json = JSON(response.result.value!)
                print(json)
                
                switch usage {
                case .obtainID:
                    let id = self.obtainID(with: json)
                    self.getInformation(with: "https://api.inrating.top/v1/users/posts/likers/all",
                                   parameters: ["id" : id], usage: .obtainLikers)
                    self.getInformation(with: "https://api.inrating.top/v1/users/posts/reposters/all",
                                        parameters: ["id" : id], usage: .obtainReposters)
                    self.getInformation(with: "https://api.inrating.top/v1/users/posts/commentators/all",
                                        parameters: ["id" : id], usage: .obtainCommenters)
                    self.getInformation(with: "https://api.inrating.top/v1/users/posts/mentions/all",
                                        parameters: ["id" : id], usage: .obtainMentioned)
                default:
                    self.obtainPeople(with: json, for: usage.rawValue)
                }
            } else {
                print("Error \(String(describing: response.result.error)).")
            }
        }
    }
    
    //MARK: - Obtaining ID of the post
    func obtainID(with json: JSON) -> String {
        
        bookmarksLabel.text = "Закладки " + json["bookmarks_count"].stringValue
        repostsLabel.text = "Репосты " + json["reposts_count"].stringValue
        viewsLabel.text = "Просмотры " + json["views_count"].stringValue
        likesLabel.text = "Лайки " + json["likes_count"].stringValue
        peopleLabel.text = "Отметки " + json["attachments"]["images"][0]["mentioned_users_count"].stringValue
        
        return json["id"].stringValue
    }
    
    func obtainPeople(with json: JSON, for row: Int) {
        
        let data = json["data"].arrayValue
        for i in 0..<data.count {
            let image = data[i]["avatar_image"]["url_medium"].stringValue
            let name = data[i]["nickname"].stringValue
            People.peoples[row].append(People(name: name, avatar: image))
        }
        
        switch row {
        case 1:
            if People.peoples[1].count != 0 {
                likesCollectionView.isHidden = false
            }
            likesCollectionView.reloadData()
        case 2:
            if People.peoples[2].count != 0 {
                commentsCollectionView.isHidden = false
            }
            commentsCollectionView.reloadData()
        case 3:
            if People.peoples[3].count != 0 {
                peopleCollectionView.isHidden = false
            }
            peopleCollectionView.reloadData()
        case 4:
            if People.peoples[4].count != 0 {
                repostsCollectionView.isHidden = false
            }
            repostsCollectionView.reloadData()
        default:
            break
        }
        tableView.reloadData()
    }
}

//MARK: - Collection and Table Views Delegate Methods
extension StatisticsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 96, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case likesCollectionView:
            return People.peoples[1].count
        case commentsCollectionView:
            commentsLabel.text = "Комментаторы \(People.peoples[2].count)"
            return People.peoples[2].count
        case peopleCollectionView:
            return People.peoples[3].count
        case repostsCollectionView:
            return People.peoples[4].count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath) as! PeopleCollectionViewCell
        switch collectionView {
        case likesCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 1)
        case commentsCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 2)
        case peopleCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 3)
        case repostsCollectionView:
            cell.configure(at: indexPath, collectionViewNumber: 4)
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if People.peoples[indexPath.section].count == 0 {
            return 44
        } else {
            return 170
        }
    }
}
