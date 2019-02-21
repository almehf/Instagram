//
//  HomeFooter.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/13/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
class HomeFooterCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "Share your first photo and video"
        lb.textColor = UIColor.rgb(red: 63, green: 58, blue: 122)
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    func setupviews() {
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
