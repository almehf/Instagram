//
//  VisitUserCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 7/4/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
class VisitUserCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    var delegate: UserProfileCellDelegate?
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else {return}
            
            photImageView.loadImage(urlString: imageUrl)
        }
    }
    
    lazy var photImageView: CustomImageView = {
        let images = CustomImageView()
        images.clipsToBounds = true
        images.layer.masksToBounds = true
        images.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePostDetails))
        images.addGestureRecognizer(tapGesture)
        images.isUserInteractionEnabled = true
        return images
    }()
    
    @objc func handlePostDetails() {
        guard let postId = post?.id else {return}
        delegate?.didTapPhoto(postId: postId)
    }
    
    
    
    
    
    func setupviews() {
        addSubview(photImageView)
        
        photImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    
    
    
    
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
