//
//  CommentController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/3/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, CommentCellDelegate {
    private let cellID = "cellid"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "paper-plane").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.title = "Comments"
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        checkIfTextFieldIsEmpty(textField: commentTextView)
        fetchComments()
    }
    
    var postId: String?
    var commentsArray = [Comment]()
    
    
    
    
  
    func fetchComments() {
        guard let postIdUnwrapped = postId else {return}
        let ref = Database.database().reference().child("Comments").child(postIdUnwrapped)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionaries["uid"] as? String else {return}
            Database.fetchUserWithUID(uid: uid, completion: { (users) in
                let comment = Comment(user: users, dictionary: dictionaries)
                self.commentsArray.append(comment)
                self.collectionView?.reloadData()
                
            })
        }) { (err) in
            print("failed to fetch dictionaries", err.localizedDescription)
        }
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
        cell.comment = commentsArray[indexPath.item]
        cell.delegate = self
        let comment = commentsArray[indexPath.item]
        checkCommentLikes(cell: cell, comment: comment)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        containerView.isHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        containerView.isHidden = true
        
        
    }
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let imageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50 / 2
        image.backgroundColor = .green
        return image
    }()
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.imageView.loadImage(urlString: user.userProfileImageUrl)
        }
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        
        
        self.submitButton.setTitle("Post", for: .normal)
        self.submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        containerView.addSubview(self.submitButton)
        self.submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
        
        
        containerView.addSubview(self.commentTextView)
//        containerView.addSubview(self.imageView)
        
        self.commentTextView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: self.submitButton.leftAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12, width: 0, height: 0)
        
//        self.imageView.anchor(top: self.commentTextView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        let lineSeperatorView = UIView()
        containerView.addSubview(lineSeperatorView)
        lineSeperatorView.backgroundColor = .gray
        lineSeperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        return containerView
    }()
    
    lazy var commentTextView: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.layer.cornerRadius = 22
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.placeholder = "Add a comment..."
        textView.addTarget(self, action: #selector(checkIfTextFieldIsEmpty(textField:)), for: .editingChanged)
        return textView
    }()
    
    @objc func handleSend() {
        guard let postIdentifier = postId else {return}
        let ref = Database.database().reference().child("Comments").child(postIdentifier)
        let commentId = ref.childByAutoId().key
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values: [String:Any] = ["postId": postIdentifier, "commentId": commentId, "commentText": commentTextView.text!, "creationDate" : Date().timeIntervalSince1970, "uid": uid]
        ref.child(commentId).updateChildValues(values) { (err, ref) in
            if err != nil {
                print("error failed to comments", err?.localizedDescription ?? "")
                return
            }

        }
        
        commentTextView.text = nil
        submitButton.isEnabled = false
    }
    
    @objc func checkIfTextFieldIsEmpty(textField: UITextField) {
        if textField.text?.isEmpty == true {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
    
    
    
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func didLikeComment(cell: CommentCell, comment: Comment) {
        guard let commentid = comment.commentId else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}


        if cell.likeButton.tintColor == UIColor.black {
            cell.likeButton.tintColor = UIColor.red
            Database.database().reference().child("CommentLikes").child(commentid).child(uid).setValue("Liked Comment")
            
        } else {
            cell.likeButton.tintColor = UIColor.black
            Database.database().reference().child("CommentLikes").child(commentid).child(uid).removeValue()
        }
    }
    
    
    func checkCommentLikes(cell: CommentCell, comment: Comment) {
        guard let commentId = comment.commentId else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("CommentLikes").child(commentId).observe(.value, with: { (snapshot) in
            let likeCount = snapshot.childrenCount
            cell.commentLikeCount.text = String(likeCount) + " " + "Likes"
            if snapshot.hasChild(uid) == true {
                cell.likeButton.tintColor = .red
            }
        }) { (err) in
            print("failed to fetch comment Likes:", err.localizedDescription)
            return
        }


    }
    
    func didTapAvatar(user: Users) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if uid == user.uid {
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(userProfileController, animated: true)
        } else {
            let userProfileController = VisitUserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.user = user
            userProfileController.userId = user.uid
            navigationController?.pushViewController(userProfileController, animated: true)
        }
        
    }
    
    
    
    
    
}




//
//fileprivate func fetchPostCommentsFromDatabase() {
//    guard let postId = postId else {return}
//    
//    let databaseRef = Database.database().reference().child("Comments").child(postId)
//    
//    databaseRef.observe(.childAdded, with: { (snapshot) in
//        
//        guard let dictionary = snapshot.value as? [String: Any] else {return}
//        guard let uid = dictionary["uid"] as? String else {return}
//        //Watch Auto size comment cells video by brian in ig course. outlines how we get the user here
//        Database.fetchUserWithUID(uid: uid, completion: { (userFromDictionaryAbove) in
//            let comments = Comment(user: userFromDictionaryAbove, dictionary: dictionary)
//            print(comments.captionText, comments.uid)
//            self.commentsArray.append(comments)
//            self.commentsArray.sort(by: { (comment1, comment2) -> Bool in
//                return comment1.creationDate.compare(comment2.creationDate) == .orderedAscending
//            })
//            self.collectionView?.reloadData()
//        })
//        
//        
//        
//    }) { (err) in
//        print("Failed to observe Comments")
//    }
//    
//    
//    
//}

