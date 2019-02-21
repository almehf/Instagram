//
//  UserProfileCreateStoriesCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/22/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
import Firebase
class UserProfileCreateStoriesCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchUser()
        setupviews()
    }
    
    
    
    
//    var delegate: CreateStoriesDelegate?
    
    var user: Users? {
        didSet {
            guard let urlString = user?.userProfileImageUrl else {return}
            stories.loadImage(urlString: urlString)
        }
    }
    
    
    lazy var stories: CustomImageView = {
        let imageview = CustomImageView()
        imageview.layer.masksToBounds = true
        imageview.clipsToBounds = true
        imageview.backgroundColor = .red
        imageview.contentMode = .scaleAspectFill
        imageview.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCreateStories(tapGesture:)))
        imageview.addGestureRecognizer(tapGesture)
        return imageview
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "You"
        return label
    }()
    
    let addStories: UIImageView = {
        let add = UIImageView(image: #imageLiteral(resourceName: "addition-button").withRenderingMode(.alwaysTemplate))
        add.tintColor = .blue
        return add
    }()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            
        }
    }
    
    @objc func handleCreateStories(tapGesture: UITapGestureRecognizer) {
//        delegate?.tapCreateStories()
    }
    
    
    func setupviews() {
        addSubview(stories)
        addSubview(nameLabel)
        addSubview(addStories)
        stories.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 60, height: 60)
        stories.layer.cornerRadius = 60 / 2
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        nameLabel.anchor(top: stories.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: stories.centerXAnchor).isActive = true
        
        addStories.anchor(top: stories.bottomAnchor, left: nil, bottom: nil, right: stories.rightAnchor, paddingTop: -20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
    }

    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
