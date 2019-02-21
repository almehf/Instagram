//
//  Post.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import Foundation
struct Post {
    //    let imageUrl: String
    var id: String?
    var user: Users
    let captionText: String?
    let imageUrl: String
    var videoUrl: String?
    let creationDate: Date
    var hasLiked: Bool = false
    var hasBookmarked: Bool = false
    
    init(user: Users
        , dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.captionText = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
         
    }
}
