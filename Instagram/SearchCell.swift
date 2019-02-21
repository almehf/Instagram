//
//  SearchCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/18/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
class SearchCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    var user: Users? {
        didSet {
            guard let urlString = user?.userProfileImageUrl else {return}
            userProfileImageView.loadImage(urlString: urlString)
            userFullNameLabel.text = user?.userFullname
            userNameLabel.text = user?.userName
        }
    }
    
    
    let userProfileImageView: CustomImageView = {
        let photo = CustomImageView()
        photo.clipsToBounds = true
        photo.backgroundColor = .red
        photo.layer.masksToBounds = true
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 60 / 2
        photo.layer.borderWidth = 0.3
        photo.layer.borderColor =  UIColor.rgb(red: 38, green: 54, blue: 112).cgColor
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    let userFullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name Test"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name Test"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let lineSeperatorView: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    
    
    
    
    func setupviews() {
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(userFullNameLabel)
        userFullNameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 15)
        
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: userFullNameLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        addSubview(lineSeperatorView)
        lineSeperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineSeperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineSeperatorView.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor, constant: 0).isActive = true
        lineSeperatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
