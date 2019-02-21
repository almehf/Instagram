//
//  ProfileHeader + Handler.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/22/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
//extension UserProfileHeader {
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//            return storiesCollectionView.dequeueReusableCell(withReuseIdentifier: createStoriesCellid, for: indexPath) as! UserProfileCreateStoriesCell
//        }
//        let cell = storiesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIDentifier, for: indexPath) as! StoriesInProfileCell
//        cell.nameLabel.text = names[indexPath.item]
//        cell.stories.image = UIImage(named: picImages[indexPath.item])
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 120, height: frame.height)
//        
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        return names.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    
//}
