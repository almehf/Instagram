//
//  VisitUserHeader.swift
//  Instagram
//
//  Created by Fahad Almehawas on 7/4/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//
protocol VisitUserHeaderDelegate {
    func didTapUnfollowUser(userId: String, cell: VisitUserHeader)
    func didTapFollowersList()
    func didTapFollowingList()
 }
import UIKit
import Firebase
class VisitUserHeader: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    var delegate: VisitUserHeaderDelegate?
    var user: Users? {
        didSet {
            userFullNameLabel.text = user?.userName
            guard let profilePhoto = user?.userProfileImageUrl else {return}
            userProfileImageView.loadImage(urlString: profilePhoto)
            checkIfFollowingUser()
            updatePostCount()
            updateFollowersLabel()
            updatefollowingLabel()
            
        }
    }
    

    
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let userFullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Testing username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    lazy var followProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
        button.layer.borderColor = UIColor.clear.cgColor
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    
    let notificationsId = Database.database().reference().childByAutoId().key
    @objc func handleFollow() {
        guard let userid = user?.uid else {return}
        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        
        let DatabaseRef = Database.database().reference().child("user").child(userid).child("followers")
        
        let value: [String: Any] = [currentUserUID: "follower"]
        DatabaseRef.updateChildValues(value)
        let followingValues = [userid: "following"]
        Database.database().reference().child("user").child(currentUserUID).child("following").updateChildValues(followingValues)
        
        self.followProfileButton.setTitle("Message", for: .normal)
        self.followProfileButton.setTitleColor(.black, for: .normal)
        self.followProfileButton.backgroundColor = UIColor.white
        self.followProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        self.settingsButtons.backgroundColor = UIColor.white
        self.settingsButtons.tintColor = .black
        self.settingsButtons.layer.borderColor = UIColor.lightGray.cgColor
        
        let databaseNotificationRef = Database.database().reference().child("Notifications").child(userid).child(notificationsId)
       

        let notifValues = ["text": "Just followed you", "uid": currentUserUID, "notificationType": "Gained a Follower", "NotificationId": notificationsId]
        databaseNotificationRef.updateChildValues(notifValues)
    }
    
    
    func checkIfFollowingUser() {
        guard let userid = user?.uid else {return}
        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        
        let DatabaseRef = Database.database().reference().child("user").child(userid).child("followers")
        
        DatabaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(currentUserUID) {
                self.followProfileButton.setTitle("Message", for: .normal)
                self.followProfileButton.setTitleColor(.black, for: .normal)
                self.followProfileButton.backgroundColor = UIColor.white
                self.followProfileButton.layer.borderColor = UIColor.lightGray.cgColor
                self.settingsButtons.backgroundColor = UIColor.white
                self.settingsButtons.tintColor = .black
                self.settingsButtons.layer.borderColor = UIColor.lightGray.cgColor

            } else {
                self.followProfileButton.setTitle("Follow", for: .normal)
                self.followProfileButton.setTitleColor(.white, for: .normal)
                self.followProfileButton.layer.borderWidth = 1
                self.followProfileButton.layer.cornerRadius = 5
                self.followProfileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                self.followProfileButton.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
                self.followProfileButton.layer.borderColor = UIColor.clear.cgColor
                self.settingsButtons.tintColor =  .white
                self.settingsButtons.layer.borderWidth = 1
                self.settingsButtons.layer.cornerRadius = 5
                self.settingsButtons.layer.borderColor = UIColor.clear.cgColor
                self.settingsButtons.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
            }
        }) { (err) in
            print("failed to follow user", err.localizedDescription)
        }
        
    }
    lazy var settingsButtons: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "triangular-arrow-pointing-down").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor =  .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor =  UIColor.rgb(red: 80, green: 151, blue: 233)
        button.addTarget(self, action: #selector(self.handleUnfollowUser), for: .touchUpInside)
        return button
    }()
    
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.text = "11\npost"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "11\nfollowers"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToFollowers))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "11\nfollowing"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToFollowing))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let bioTextField: UITextView = {
        let textview = UITextView()
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.text = "Testing caption and stuff"
        return textview
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.rgb(red: 80, green: 151, blue: 233)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "small-bookmark").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let tagButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    let bottomLineDivider: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    let topLineDivider: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    
    @objc func handleUnfollowUser() {
        if followProfileButton.title(for: .normal) == "Message" {
            guard let userId = user?.uid else {return}
            delegate?.didTapUnfollowUser(userId: userId, cell: self)
        }
        
    }
    
    
    
    func updatePostCount() {
        guard let uid = user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observe(.value, with: { (snapshot) in
            let postsCount: Int = Int(snapshot.childrenCount)
            
            let bookAttributedText = NSMutableAttributedString(string: "\(String(postsCount)) \n", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            
            bookAttributedText.append(NSMutableAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
            self.postLabel.attributedText = bookAttributedText
            
            
        })
    }
    
    
    
    func updateFollowersLabel() {
        guard let uid = user?.uid else {return}
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        let followers: String = "followers"
        let ref = Database.database().reference().child("user").child(uid).child(followers)
        ref.observe(.value, with: { (snapshot) in
            let followersCount: Int = Int(snapshot.childrenCount)
            self.followersLabel.textColor = .white
            
            let bookAttributedText = NSMutableAttributedString(string: "\(String(followersCount)) \n", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            
            bookAttributedText.append(NSMutableAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
            self.followersLabel.attributedText = bookAttributedText
            
            
        })
        
        
    }
    
    func updatefollowingLabel() {
        guard let uid = user?.uid else {return}
        let followers: String = "following"
        let ref = Database.database().reference().child("user").child(uid).child(followers)
        ref.observe(.value, with: { (snapshot) in
            let followersCount: Int = Int(snapshot.childrenCount)
            self.followingLabel.textColor = .white
            
            let bookAttributedText = NSMutableAttributedString(string: "\(String(followersCount)) \n", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            
            bookAttributedText.append(NSMutableAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
            self.followingLabel.attributedText = bookAttributedText
            
            
        })
        
        
    }

    
    @objc func handleNavigateToFollowers() {
        delegate?.didTapFollowersList()
    }
    
    @objc func handleNavigateToFollowing() {
        delegate?.didTapFollowingList()
    }
    
    func setupviews() {
        addSubview(userProfileImageView)
        addSubview(userFullNameLabel)
        addSubview(bioTextField)
        addSubview(bottomLineDivider)
        addSubview(topLineDivider)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        userProfileImageView.layer.cornerRadius = 80 / 2
        
        userFullNameLabel.anchor(top: userProfileImageView.bottomAnchor, left: userProfileImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        bioTextField.anchor(top: userFullNameLabel.bottomAnchor, left: userFullNameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        
        setupInPutTextFields()
        
    }
    
    
    func setupInPutTextFields() {
        
        let stackview = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        
        let gridListStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        
        stackview.axis = .horizontal
        stackview.spacing = 10
        addSubview(stackview)
        addSubview(followProfileButton)
        addSubview(settingsButtons)
        addSubview(gridListStackView)
        addSubview(topLineDivider)
        addSubview(bottomLineDivider)
        
        
        stackview.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        followProfileButton.anchor(top: stackview.bottomAnchor, left: stackview.leftAnchor, bottom: nil, right: settingsButtons.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 30)
        
        settingsButtons.anchor(top: followProfileButton.topAnchor, left: followProfileButton.rightAnchor, bottom: followProfileButton.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 4, width: 40, height: 0)
        
        
        gridListStackView.axis = .horizontal
        gridListStackView.spacing = 10
        gridListStackView.distribution = .fillEqually
        
        gridListStackView.anchor(top: nil, left: bioTextField.leftAnchor, bottom: bottomAnchor, right: bioTextField.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        topLineDivider.anchor(top: nil, left: leftAnchor, bottom: gridListStackView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 2, paddingRight: 0, width: 0, height: 1)
        
        bottomLineDivider.anchor(top: gridListStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
