//
//  LikeListController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/13/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class LikeListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellid = "JESUS IS KING"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellid)
        collectionView?.backgroundColor = .white
        fetchWhoLikedPostFromDB()
    }
    
    var postId: String?
    var userProfiles = [Users]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func fetchWhoLikedPostFromDB() {
        guard let postIdRef = postId else {return}
        Database.database().reference().child("Like").child(postIdRef).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let likeDict = snapshot.value as? [String: Any] else {return}
            likeDict.forEach({ (key, value) in
                Database.database().reference().child("user").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userDicts = snapshot.value as? [String: Any] else {return}
                    let user = Users(uid: key, dictionary: userDicts)
                    self.userProfiles.append(user)
                    self.navigationItem.title = String(self.userProfiles.count) + " " + "Like"
                    self.collectionView?.reloadData()
                }, withCancel: { (err) in
                    print("failed to fetch users", err.localizedDescription)
                })
            })
        }) { (err) in
            print("Failed to fetch list of users who liked post", err.localizedDescription)
        }
    }
    
    //cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! SearchCell
        cell.user = userProfiles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userProfiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userUid = userProfiles[indexPath.item].uid
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        if currentUid == userUid {
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(userProfileController, animated: true)
        } else {
            
            let vistUserProfileController = VisitUserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            vistUserProfileController.userId = userUid
            self.navigationController?.pushViewController(vistUserProfileController, animated: true)
        }
    }
}
