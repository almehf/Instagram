//
//  FollowersController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/22/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.

import UIKit
import Firebase
class FollowingsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellid = "cellid"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellid)
        collectionView?.backgroundColor = .white
        navigationItem.title = "Following"

        fetchUser()
        fetchFollowersList()
    }
    
    
    var user: Users?
    var userId: String?
    var userProfiles = [Users]()
    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        Database.database().reference().child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userObjectDictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = Users(uid: uid, dictionary: userObjectDictionary)
            self.navigationItem.title = self.user?.userFullname
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch readers:", err)
        }
        
    }
    
    func fetchFollowersList() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        let ref = Database.database().reference().child("user").child(uid).child("following")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followersDictionaries = snapshot.value as? [String: Any] else {return}
            followersDictionaries.forEach({ (key, value) in
                
                let followersUserId = key
                Database.database().reference().child("user").child(followersUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userdict = snapshot.value as? [String: Any] else {return}
                    let followers = Users(uid: key, dictionary: userdict)
                    self.userProfiles.append(followers)
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("failed to fetch users", err.localizedDescription)
                })
                
                
            })
        }) { (err) in
            print("failed to fetch followers List", err.localizedDescription)
        }
    }
    
    
    
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
        
        let userInFollowersList = userProfiles[indexPath.item]
        
        guard let currenLoggedInUserUid = Auth.auth().currentUser?.uid else {return}
        
        if currenLoggedInUserUid == userInFollowersList.uid {
            let myProfileComtroller = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            
            self.navigationController?.pushViewController(myProfileComtroller, animated: true)
        } else {
            let userProfileController = VisitUserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            
            
            userProfileController.userId = userInFollowersList.uid
            
            
            self.navigationController?.pushViewController(userProfileController, animated: true)
            
            
        }
    }
}
