//
//  Database.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (Users) -> ()) {
        print("fetching user:", uid)
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let user = Users(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("failed to fetch user:", err.localizedDescription)
            return
        }
    }
}
