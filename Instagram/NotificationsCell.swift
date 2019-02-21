//
//  NotificationsCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 7/1/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//
protocol NotificationsCellDelegate {
    func didNavigateToVisitUserProfile(userId: String)
    func didTapPostImage(postId: String, userId: String)

}
import UIKit
class NotificationsCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    var delegate: NotificationsCellDelegate?
    var notification: Notifications? {
        didSet {
            guard let urlString = notification?.user.userProfileImageUrl else {return}
            userProfileImageView.loadImage(urlString: urlString)
            userFullNameLabel.text = notification?.user.userFullname
            notificationText.text = notification?.text
            
            
            
            guard let postUrlString = notification?.postImageUrl else {return}
            postImage.loadImage(urlString: postUrlString)
            
            //if notif has no post then remove postImage
            if postUrlString.isEmpty == true {
                postImage.alpha = 0
            }
           
        }
    }
    
    lazy var userProfileImageView: CustomImageView = {
        let photo = CustomImageView()
        photo.clipsToBounds = true
        photo.backgroundColor = .white
        photo.layer.masksToBounds = true
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 60 / 2
        photo.layer.borderWidth = 0.3
        photo.layer.borderColor =  UIColor.rgb(red: 38, green: 54, blue: 112).cgColor
        photo.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToUserProfile))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    lazy var postImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToPostDetails))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var userFullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name Test"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToUserProfile))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    let notificationText: UILabel = {
        let label = UILabel()
        label.text = "User Name Test"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let lineSeperatorView: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    @objc func handleNavigateToUserProfile() {
        guard let userId = notification?.user.uid else {return}
        delegate?.didNavigateToVisitUserProfile(userId: userId)
    }
    
    @objc func handleNavigateToPostDetails() {
        guard let postId = notification?.postId else {return}
        guard let userId = notification?.uid else {return}
        delegate?.didTapPostImage(postId: postId, userId: userId)
    }
    
    func setupviews() {
        addSubview(userProfileImageView)
        addSubview(postImage)
        addSubview(userFullNameLabel)
        addSubview(notificationText)
        addSubview(lineSeperatorView)
        addSubview(postImage)
        userProfileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userFullNameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 15)
        
        
        notificationText.anchor(top: userFullNameLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        lineSeperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineSeperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineSeperatorView.leftAnchor.constraint(equalTo: notificationText.leftAnchor, constant: 0).isActive = true
        lineSeperatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        postImage.anchor(top: userProfileImageView.topAnchor, left: nil, bottom: userProfileImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 3, width: 60, height: 60)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
