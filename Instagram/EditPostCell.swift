//
//  EditPostCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//
protocol EditPostCellDelegate {
    func didChangeText(text: String)
}
import UIKit
import Firebase
class EditPostCell: UICollectionViewCell, UITextViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupviews()
    }
    
    var delegate: EditPostCellDelegate?
    var post: Post? {
        didSet {
            guard let urlString = post?.user.userProfileImageUrl else {return}
            userProfileImageView.loadImage(urlString: urlString)
            guard let postUrlString = post?.imageUrl else {return}
            postImageView.loadImage(urlString: postUrlString)
            userNameLabel.text = post?.user.userFullname
            
            editPostTextView.text = post?.captionText
        }
    }
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Fahad"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let addLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Location..."
        return label
    }()
    
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green
        return imageView
    }()
    
    lazy var editPostTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        delegate?.didChangeText(text: textView.text)
    }
    
 
    
    func setupviews() {
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(addLocationLabel)
        addSubview(postImageView)
        addSubview(editPostTextView)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 50, height: 50)
        userProfileImageView.layer.cornerRadius = 50 / 2
        
        userNameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 6, width: 0, height: 0)
        
        
        addLocationLabel.anchor(top: userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor, bottom: nil, right: userNameLabel.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: editPostTextView.topAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        editPostTextView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
