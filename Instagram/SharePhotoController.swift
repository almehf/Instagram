//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/25/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class SharePhotoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupSubviews()
        setupShareButton()
    }
    
    var selectedImage: UIImage? {
        didSet {
            photoView.image = selectedImage
        }
    }

    
    func setupShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleUploadToDatabase))

    }
    
    
    let photoView: UIImageView = {
        let photo = UIImageView()
        photo.backgroundColor = .blue
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    let captiontv: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = .white
        return tv
    }()
    
    
    @objc func handleUploadToDatabase() {
        guard let image = selectedImage else {return}
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let filename = NSUUID().uuidString
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                print("Failed to upload post image:", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
            print("Successfully uploaded post image:", imageUrl)
            
            self.saveToDatabaseWithImageUrl(appendImageUrl: imageUrl)
            
        }
        
    }
    
    fileprivate func saveToDatabaseWithImageUrl(appendImageUrl: String) {
        guard let currentLoggedInUserUid = Auth.auth().currentUser?.uid else {return}
        guard let captionText = captiontv.text else {return}
        guard let postImage = selectedImage else {return}
        let postId = Database.database().reference().childByAutoId().key
        let ref = Database.database().reference().child("posts").child(currentLoggedInUserUid).child(postId)
        
        let values: [String: Any] = ["imageUrl": appendImageUrl, "caption": captionText, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970, "postId": postId, "uid": currentLoggedInUserUid]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post to DB", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            self.postNotifications()
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func postNotifications() {
        let name: Notification.Name = Notification.Name(rawValue: "Notification")
        NotificationCenter.default.post(name: name, object: self, userInfo: nil)
    }

    
    fileprivate func setupSubviews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(photoView)
        containerView.addSubview(captiontv)
        //toplayout guide
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        photoView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 84, height: 0)
        captiontv.anchor(top: containerView.topAnchor, left: photoView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}
