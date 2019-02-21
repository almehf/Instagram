//
//  NotificationsController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 7/1/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class NotificationsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NotificationsCellDelegate {
    private let cellID = "CELLID"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(NotificationsCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .white
        self.navigationItem.title = "Notifications"
//        fetchNotificationsFromDB()
        observeNotifications()
    }
    
    var notifications = [Notifications]()
    
    
    
    func fetchNotificationsFromDB() {
        guard let uid = Auth.auth().currentUser?.uid  else {return}
        
        let ref = Database.database().reference().child("Notifications").child(uid)
        
        ref.observe( .value, with: { (snapshot) in
            guard let notifDictionaries = snapshot.value as? [String: Any] else {return}
            notifDictionaries.forEach({ (key, value) in
                guard let notificationDictionary = value as? [String: Any] else {return}
                
                let userId = notificationDictionary["uid"] as? String ?? ""
//                let postId = notificationDictionary["postId"] as? String ?? ""
                
                
                Database.database().reference().child("user").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userDictionary = snapshot.value as? [String: Any] else {return}
                    
                    let user = Users(uid: userId, dictionary: userDictionary)
                    if userId == uid {
                        print("found that i liked my own post, omit notification")
                        return
                    }
                    let notification = Notifications(user: user, dictionary: notificationDictionary)
                    self.notifications.append(notification)
                    self.collectionView?.reloadData()
                })
            })
        }) { (err) in
            print("failed to fetch notifications", err.localizedDescription)
        }
    }
    
    
    func observeNotifications() {
        guard let uid = Auth.auth().currentUser?.uid  else {return}
        
        let ref = Database.database().reference().child("Notifications").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let notificationsDict = snapshot.value as? [String:Any] else {return}
            
            guard let uid = notificationsDict["uid"] as? String else {return}
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                var notification = Notifications(user: user, dictionary: notificationsDict)
                self.notifications.append(notification)
                self.collectionView?.reloadData()

            })
        }) { (err) in
            print("failed to fetch notifications", err.localizedDescription)
            return
        }
        
        //observe deleted notifications
        ref.observe(.childRemoved, with: { (snapshot) in
            print(snapshot.key)
            guard let deletedNotificationDict = snapshot.value as? [String:Any] else {return}
            guard let uid = deletedNotificationDict["uid"] as? String else {return}
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
            let deletedNotifications = Notifications(user: user, dictionary: deletedNotificationDict)
                print("Deleted Notifications\(deletedNotifications)")
//                
//                let row = companies.index(of: company)
//                let reloadIndexPath = IndexPath(row: row!, section: 0)
//                tableView.reloadRows(at: [reloadIndexPath], with: .top)

            })
            
        }) { (err) in
            print("failed to remove notifications", err.localizedDescription)
            return
        }
      
    }
  
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NotificationsCell
        cell.notification = notifications[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func didNavigateToVisitUserProfile(userId: String) {
        let visitUserProfileController = VisitUserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        visitUserProfileController.userId = userId
        navigationController?.pushViewController(visitUserProfileController, animated: true)
        
    }
    
    func didTapPostImage(postId: String, userId: String) {
//        let postDetailsController = PostDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
//        postDetailsController.postId = postId
//        postDetailsController.userId = userId
//        navigationController?.pushViewController(postDetailsController, animated: true)
        
    }
    
    
}
