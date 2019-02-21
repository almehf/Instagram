//
//  HomeController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/13/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
import SVProgressHUD
class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    func didLike(for cell: HomeCell) {
        print("dfg")
    }
    
    let cellId = "Cellid"
    let headerId = "HeaderId"
    let footerId = "FooterId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(HomeFooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysTemplate))
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        logo.layer.masksToBounds = true
        navigationItem.titleView = logo
        logo.tintColor = .black
        
//        fetchPosts()
        fetchFollowingUserIds()
//        observeNewPost()
        setupNavController()
        fetchAllPosts()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: Users) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    //                    print(snapshot)
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    func parsePostJsonToObjects(user: Users, postId: String) {
        Database.database().reference().child("posts").child(user.uid).child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postDicts = snapshot.value as? [String: Any] else {return}
            var post = Post(user: user, dictionary: postDicts)
            post.id = postId
            self.posts.append(post)
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("failed to fetch Posts in home feed", err.localizedDescription)
        }
        
    }
    
    
    func fetchFollowingUserIds() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("user").child(currentLoggedInUserId).child("following").observe(.value, with: { (snapshot) in
            guard let userIdDicts = snapshot.value as? [String:Any] else {return}
            userIdDicts.forEach({ (key, value) in
                let userIds = key
                print("following Ids \(userIds)")
                Database.fetchUserWithUID(uid: userIds, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (err) in
            print("failed to fetch following UserIds:", err.localizedDescription)
            return
        }
    }
    
    func observeNewPost() {
        let name: Notification.Name = Notification.Name(rawValue: "Notification")
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserProfileUI), name: name, object: nil)
        
    }
    
    @objc func updateUserProfileUI() {
        posts.removeAll()
        fetchPosts()
        fetchFollowingUserIds()
        self.collectionView?.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        let postRef = posts[indexPath.item]
        cell.post = postRef
        cell.delegate = self
//        cell.commentDelegate = self
//        cell.playButtton.isHidden = postRef.videoUrl?.isEmpty == true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let videoPost = posts[indexPath.item].captionText {
//            if videoPost.isEmpty {
                var height: CGFloat = 40 + 5 + 5
                height += view.frame.width
                height += 50
                height += 60
                let width = view.frame.width
                return CGSize(width: width, height: height)
                
//            }
        }
        
        let width = view.frame.width
        return CGSize(width: width, height: width)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("the post count is :\(posts.count)")
        return posts.count
    }
    
    //Header
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
//            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeaderCell
//            headerCell.delegate = self
//            return headerCell
//        }
//        let footerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! HomeFooterCell
//        return footerCell
  //  }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 150)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
////        return posts.count == 0 ? 150 : 0
//        return posts.count == 0 ? CGSize(width: view.frame.width, height: 150) : CGSize(width: 0, height: 0)
//    }
    
    
    func setupNavController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera_").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenCamera))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dm").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    
    @objc func handleOpenCamera() {
        let photoController = CameraController()
        navigationController?.pushViewController(photoController, animated: true)
    }
    
    
    func didNavigateToProfile() {
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    func didNavigateToVisitUserProfile(userId: String) {
        let userProfileController = VisitUserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = userId
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    func didTapComment(post: Post) {
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.postId = post.id
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didTapBookmark(postId: String, post: Post, cell: HomeCell) {
        //bookmarking
        if cell.bookmarkButton.tintColor == UIColor.lightGray {
            print("Bookamrking")
            cell.bookmarkButton.tintColor = .black
            cell.bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark-black-shape").withRenderingMode(.alwaysTemplate), for: .normal)
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("Bookmark").child(currentUserUid).child(postId)
            let values = [post.user.uid: "Bookmarked"]
            ref.updateChildValues(values)
            SVProgressHUD.showSuccess(withStatus: "Post Bookmarked!")
            SVProgressHUD.dismiss(withDelay: 0.8)
            
        } else if cell.bookmarkButton.tintColor == UIColor.black{
            //Removing Bookmark
            cell.bookmarkButton.tintColor = .lightGray
            cell.bookmarkButton.setImage(#imageLiteral(resourceName: "small-bookmark").withRenderingMode(.alwaysTemplate), for: .normal)
            SVProgressHUD.showSuccess(withStatus: "Bookmark Removed!")
            SVProgressHUD.dismiss(withDelay: 0.8)
            guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("Bookmark").child(currentUserUid).child(postId)
            
            ref.removeValue()
            
            print("removing bookmark")
        }
    }
    
    let notificationsId = Database.database().reference().childByAutoId().key
    func didTapLike(postId: String, cell: HomeCell, post: Post) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        
        if cell.likeButton.tintColor == UIColor.lightGray {
            //Liking photo
            guard let uid = Auth.auth().currentUser?.uid else {return}
            //            guard let postid = self.postId else {return}
            let ref = Database.database().reference().child("Like").child(postId).child(uid)
            ref.setValue("Post Liked!")
            cell.likeButton.tintColor = UIColor.red
            cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysTemplate), for: .normal)
            //update notification node
            guard let userid = cell.post?.user.uid else {return}
            
            let databaseNotificationRef = Database.database().reference().child("Notifications").child(userid).child(notificationsId)
            let notifValues = ["text": "Just liked your post", "uid": currentUserUID, "notificationType": "Gained a post Like", "NotificationId": notificationsId, "postImageUrl": post.imageUrl, "postUserId": post.user.uid, "postId": postId] as [String : Any]
            databaseNotificationRef.updateChildValues(notifValues)
            
        } else {
            //unliking photo
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("Like").child(postId).child(uid)
            ref.removeValue()
            cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
            cell.likeButton.tintColor = .lightGray
            
            guard let userid = cell.post?.user.uid else {return}
            
            //removing notifications from server
            let databaseNotificationRef = Database.database().reference().child("Notifications").child(userid).child(notificationsId)
            databaseNotificationRef.removeValue()
            
            
        }
    }
    
    
    func didTapLikeList(postId: String) {
        let likeList = LikeListController(collectionViewLayout: UICollectionViewFlowLayout())
        likeList.postId = postId
        self.navigationController?.pushViewController(likeList, animated: true)
        
    }
    
    func tapCreateStories() {
        let postPhotoController = CameraController()
        let navController = UINavigationController(rootViewController: postPhotoController)
        present(navController, animated: true, completion: nil)
    }
    
    func tapViewStories() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let storiesController = OpenStoriesController(collectionViewLayout: layout)//StoriesController()
//        present(storiesController, animated: true, completion: nil)
    }
    
    func didTapMoreOptions(post: Post) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let archiveAction = UIAlertAction(title: "Archive", style: .default, handler: nil)
        let commentAction = UIAlertAction(title: "Turn Off Commenting", style: .default, handler: nil)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            self.handleEditPosts(post: post)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.handleDeletePost(post: post)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(archiveAction)
        alertController.addAction(commentAction)
        alertController.addAction(editAction)
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    private func handleDeletePost(post: Post) {
        let uid = post.user.uid
        guard let videoUrl = post.videoUrl else {return}
        let imageUrl = post.imageUrl
        guard let postUniqueId = post.id else {return}
        Database.database().reference().child("posts").child(uid).child(postUniqueId).removeValue { (err, response) in
            if err != nil {
                print("Failed to delete Posts:", err?.localizedDescription ?? "")
                return
            }
            if post.videoUrl?.isEmpty == false {
                self.deleteVideoDataFromStorage(videoUrl: videoUrl)
                self.deleteImageDataFromStorage(imageUrl: imageUrl)
            } else {
                self.deleteImageDataFromStorage(imageUrl: imageUrl)
            }
            self.postNotifications()

        }
        
    }
    
    func deleteVideoDataFromStorage(videoUrl: String) {
        Storage.storage().reference(forURL: videoUrl).delete { (error) in
            if error != nil {
                print("Failed to delete data from storage:", error?.localizedDescription ?? "")
                return
            }
            print("Successfully deleted data from storage")
        }
        
        
        
    }
    
    func deleteImageDataFromStorage(imageUrl: String) {
        Storage.storage().reference(forURL: imageUrl).delete { (error) in
            if error != nil {
                print("Failed to delete postImageUrl:", error?.localizedDescription ?? "")
                return
            }
            print("Successfully deleted imageUrl from storage")
        }
    }
    
    //updates user profile controller UI
    func postNotifications() {
        let name: Notification.Name = Notification.Name(rawValue: "Notification")
        NotificationCenter.default.post(name: name, object: self, userInfo: nil)
    }
    
    func handleEditPosts(post: Post) {
        print("Editing\(post.captionText)")
        
        let editProfileController = EditPostController(collectionViewLayout: UICollectionViewFlowLayout())
        editProfileController.post = post
        let navController = UINavigationController(rootViewController: editProfileController)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    
    
    
}
