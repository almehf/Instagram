//
//  Comment.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
struct Comment {
    var commentId: String?
    let user: Users
    let captionText: String?
    let imageUrl: String
    let creationDate: Date
    var postId: String?
    var uid: String
    init(user: Users
        , dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.captionText = dictionary["commentText"] as? String ?? ""
        self.commentId = dictionary["commentId"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.postId = dictionary["postId"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
