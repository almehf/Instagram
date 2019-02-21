//
//  SearchController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/18/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    private let cellID = "Cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag

        setupSearchBar()
        fetchUsersFromDB()
        
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func setupSearchBar() {
       
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    var users = [Users]()
    
    var filteredUsers = [Users]()
    
    func fetchUserWithFullName(searchText: String) {
        filteredUsers = [Users]()
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        let databaseQuery = Database.database().reference().child("users").queryOrdered(byChild: "username").queryStarting(atValue: searchText.lowercased()).queryEnding(atValue: searchText.lowercased()+"\u{f8ff}")
        
        databaseQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let userDictionary = value as? [String: Any] else {return}
                
                let user = Users(uid: key, dictionary: userDictionary)
                if key == currentUserUid {
                    print("found myself omit")
                    return
                }
                let isContained = self.filteredUsers.contains(where: { (containedUser) -> Bool in
                    return user.uid == containedUser.uid
                })
                if !isContained {
                    self.filteredUsers.append(user)
                    self.collectionView?.reloadData()
                }
            })
        }) { (err) in
            print("failed to query users from Database")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            print("doing nothing")
            filteredUsers = users
            users.removeAll()
            
            fetchUsersFromDB()
        } else {
            fetchUserWithFullName(searchText: searchText)
        }
        self.collectionView?.reloadData()
    }
    
    func fetchUsersFromDB() {
                let ref = Database.database().reference().child("users")
                guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
                ref.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionaries = snapshot.value as? [String: Any] else {return}
                    dictionaries.forEach({ (key, value) in
                        guard let userDictionary = value as? [String: Any] else {return}
                        let user = Users(uid: key, dictionary: userDictionary)
                        if key == currentUserUid {
                            print("found myself omit")
                            return
                        }
                        self.users.append(user)
                        self.users.sort(by: { (user1, user2) -> Bool in
                            return user1.userFullname.compare(user2.userFullname) == .orderedAscending
                        })
                        self.filteredUsers = self.users
                        self.collectionView?.reloadData()
                    })
                }) { (err) in
                    print("Failed to fetch users:", err)
                }
            }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let layout = UICollectionViewFlowLayout()
        let users = filteredUsers[indexPath.item]
        let visitUserProfileController = VisitUserProfileController(collectionViewLayout: layout)
        visitUserProfileController.userId = users.uid
        self.navigationController?.pushViewController(visitUserProfileController, animated: true)
    }
    
}



//
//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    
//    if searchText.isEmpty {
//        filteredUsers = users
//    } else {
//        self.filteredUsers = self.users.filter({ (user) -> Bool in
//            return user.userFullname.lowercased().contains(searchText.lowercased())
//        })
//        
//    }
//    self.collectionView?.reloadData()
//    
//}


//    func fetchUsersFromDB() {
//        let ref = Database.database().reference().child("user")
//
//        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
//
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard let dictionaries = snapshot.value as? [String: Any] else {return}
//
//            dictionaries.forEach({ (key, value) in
//
//                guard let userDictionary = value as? [String: Any] else {return}
//                let user = Users(uid: key, dictionary: userDictionary)
//                if key == currentUserUid {
//                    print("found myself omit")
//                    return
//                }
//                self.users.append(user)
//                self.users.sort(by: { (user1, user2) -> Bool in
//                    return user1.userFullname.compare(user2.userFullname) == .orderedAscending
//                })
//                self.filteredUsers = self.users
//                self.collectionView?.reloadData()
//            })
//        }) { (err) in
//            print("Failed to fetch users:", err)
//        }
//    }
//

