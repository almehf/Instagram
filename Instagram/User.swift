//
//  User.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//

import UIKit
struct Users {
    let userFullname: String
    let userProfileImageUrl: String
    let userBio: String?
    let userEmail: String
    let userName: String
    var uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.userFullname = dictionary["userFullname"] as? String ?? ""
        self.userProfileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.userEmail = dictionary["userEmail"] as? String ?? ""
        self.userBio = dictionary["userBio"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
    }
}
