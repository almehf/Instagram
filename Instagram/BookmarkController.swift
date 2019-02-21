//
//  BookmarkController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/13/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class BookmarkController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileCellDelegate {
    private let cellid = "CELLID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: cellid)
        collectionView?.backgroundColor = .white
        navigationItem.title = "Saved"
        setupNavItems()
        fetchBookmarkedPost()
    }
    
    
    func setupNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-symbol").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    var userId: String?
    var users: Users?
    var bookmarkedPosts = [Post]()
    

    func fetchBookmarkedPost() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Bookmark").child(uid).observe(.childAdded, with: { (snapshot) in
            guard let dicts = snapshot.value as? [String:Any] else {return}
            print(snapshot.key)
            let postId = snapshot.key
            dicts.forEach({ (key, value) in
                let userId = key
                self.fetchPostWithId(userId: userId, postId: postId)
            })
            
        }) { (err) in
            print("failed to fetch book marked dicts:", err.localizedDescription)
        }
    }
    
    func fetchPostWithId(userId: String, postId: String) {
        Database.database().reference().child("posts").child(userId).child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postDict = snapshot.value as? [String:Any] else {return}
            guard let uid = postDict["uid"] as? String else {return}
            guard let postId = postDict["postId"] as? String else {return}
            print(postId)
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
            var post = Post(user: user, dictionary: postDict)
            post.id = postId
                print(post)
            self.bookmarkedPosts.append(post)
                self.collectionView?.reloadData()

            })
          
        }) { (err) in
            print("failed to fetch posts dicts", err.localizedDescription)
            return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! UserProfileCell
        cell.post = bookmarkedPosts[indexPath.item]
        cell.post?.id = bookmarkedPosts[indexPath.item].id
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width , height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
   
    func didTapPhoto(postId: String) {
//        let postDetailsCell = PostDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
//        postDetailsCell.postId = postId
//        postDetailsCell.userId = users?.uid
//        navigationController?.pushViewController(postDetailsCell, animated: true)
    }
    
    
}
