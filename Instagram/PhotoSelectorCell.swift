//
//  PhotoSelectorCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/14/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
class PhotoSelectorCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupviews()
    }
    
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()
    
    func setupviews() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
