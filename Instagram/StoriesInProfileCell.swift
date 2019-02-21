//
//  StoriesInProfileCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/22/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
class StoriesInProfileCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    let stories: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.masksToBounds = true
        imageview.clipsToBounds = true
        imageview.backgroundColor = .red
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "JtPaase"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    
    
    func setupviews() {
        addSubview(stories)
        addSubview(nameLabel)
                
        
        stories.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 60, height: 60)
        stories.layer.cornerRadius = 60 / 2
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        nameLabel.anchor(top: stories.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: stories.centerXAnchor, constant: 0).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
