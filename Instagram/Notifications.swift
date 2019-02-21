//
//  Notifications.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
struct Notifications {
//    var id: String
    let text: String
    let notificationType: String
    let uid: String
    let user: Users
    var sender: String?
    var postImageUrl: String?
    var postId: String?
    var creationDate: Date?
    
    init(user: Users, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.notificationType = dictionary["notificationType"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""


        
        
        
    }
}
