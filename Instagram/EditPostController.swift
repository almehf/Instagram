//
//  EditPostController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
import Firebase
class EditPostController: UICollectionViewController, EditPostCellDelegate {
    let editCellId = "Cellid"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(EditPostCell.self, forCellWithReuseIdentifier: editCellId)
        setupNavItems()
    }
    
    var post: Post?
    var caption: String?
    
    func setupNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        navigationItem.title = "Edit Info"
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black

    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        guard let uid = post?.user.uid else {return}
        guard let postId = post?.id else {return}
        guard let text = caption else {return}
        let ref = Database.database().reference().child("posts").child(uid).child(postId).child("caption")
        ref.setValue(text) { (err, _) in
            if err != nil {
                print("Failed to edit Post:", err?.localizedDescription ?? "")
                return
            }
            print("Successfully edited Post Caption!")
            self.dismiss(animated: true, completion: {
                self.postNotifications()
            })
        }
    }
    

    
    func didChangeText(text: String) {
        caption = text
    }

    //updates user profile controller UI
    func postNotifications() {
        let name: Notification.Name = Notification.Name(rawValue: "Notification")
        NotificationCenter.default.post(name: name, object: self, userInfo: nil)
    }
    
}
