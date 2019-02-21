//
//  VisitUserProfileController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 7/4/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class VisitUserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileCellDelegate, VisitUserHeaderDelegate {
    
    private let cellID = "CELLID"
    private let headerID = "HEADERID"
    
    override func viewDidLoad() {
        collectionView?.register(VisitUserCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(VisitUserHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.backgroundColor = .white
        fetchUser()
        fetchOrderedPosts()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: nil)


    }
    
    var user: Users?
    var posts = [Post]()
    
    var userId: String?

    func fetchUser() {
        guard let uid = userId else {return}
        
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = Users(uid: uid, dictionary: userDictionary)
            self.collectionView?.reloadData()
        }) { (err) in
            print("failed to fetch user", err)
        }
    }
    
    func fetchOrderedPosts() {
        
        guard let uid = userId else {return}

        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                
                guard let postDictionary = value as? [String: Any] else {return}
                
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userDict = snapshot.value as? [String: Any] else {return}
                    let userObject = Users(uid: uid, dictionary: userDict)
                    self.user = Users(uid: uid, dictionary: userDict)
                    var post = Post(user: userObject, dictionary: postDictionary)
                    post.id = key
                    self.posts.append(post)
                    self.posts.sort(by: { (post1, post2) -> Bool in
                        return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()


                })
                
//                               self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("failed to fetch user post:", err)
        }

    }
    
    
   
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! VisitUserCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width , height: width)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    }
    
    
    //header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! VisitUserHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func didTapPhoto(postId: String) {
//        let postCellDetails = PostDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
//        postCellDetails.postId = postId
//        postCellDetails.userId = userId
//        navigationController?.pushViewController(postCellDetails, animated: true)
    }
    
    func didTapUnfollowUser(userId: String, cell: VisitUserHeader) {
        
        guard let username = user?.userName else {return}
        
        let alertController = UIAlertController(title: "Unfollow \(username)?", message: nil, preferredStyle: .actionSheet)
        
        present(alertController, animated: true, completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Unfollow", style: .destructive, handler: { (_) in
            
            guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
            
            let DatabaseRef = Database.database().reference().child("users").child(userId).child("followers").child(currentUserUID)
            
            DatabaseRef.removeValue()
            
            Database.database().reference().child("users").child(currentUserUID).child("following").child(userId).removeValue()
            
            cell.followProfileButton.setTitle("Follow", for: .normal)
            cell.followProfileButton.setTitleColor(.white, for: .normal)
            cell.followProfileButton.layer.borderWidth = 1
            cell.followProfileButton.layer.cornerRadius = 5
            cell.followProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.followProfileButton.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
            cell.followProfileButton.layer.borderColor = UIColor.clear.cgColor
            cell.settingsButtons.tintColor =  .white
            cell.settingsButtons.layer.borderWidth = 1
            cell.settingsButtons.layer.cornerRadius = 5
            cell.settingsButtons.layer.borderColor = UIColor.clear.cgColor
            cell.settingsButtons.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
            
            //removing notifications from database
            let notificationsID = cell.notificationsId
             Database.database().reference().child("Notifications").child(userId).child(notificationsID).removeValue()
        }))
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (nil) in
        }))
        
        
    }
    
    func didTapFollowingList() {
        let followingController = FollowingsController(collectionViewLayout: UICollectionViewFlowLayout())
        followingController.userId = userId
        navigationController?.pushViewController(followingController, animated: true)
    }
    
    func didTapFollowersList() {
        let followersController = FollowersController(collectionViewLayout: UICollectionViewFlowLayout())
        followersController.userId = userId
        navigationController?.pushViewController(followersController, animated: true)

    }
    
}
