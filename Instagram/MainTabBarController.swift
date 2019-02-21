//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/12/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelector = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelector)
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        if Auth.auth().currentUser == nil {
            //this dispatches.main protocol takes us from background running to mainmode of loginviewcontroller
            DispatchQueue.main.async {
                let welcomePageController  = ViewController()
                let navController = UINavigationController(rootViewController: welcomePageController)
                self.present(navController, animated: true, completion: nil)
        
            }
        }
        setupViewControllers()

    }
    
    
    func setupViewControllers() {
        
        //HomeNav
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: homeController)
        
        //addPhoto
        let uploadPhotoController = templateNavController(unselectedImage: #imageLiteral(resourceName: "upload-unselect"), selectedImage: #imageLiteral(resourceName: "upload-unselect"))
        
        //search
        let searchController = SearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: searchController)
        
        //likeNav
        let likeLayout = UICollectionViewFlowLayout()
        let notificationsController = NotificationsController(collectionViewLayout: likeLayout)
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: notificationsController)
        
        
        //userprofilecontroller
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
                tabBar.tintColor = .black
                tabBar.isTranslucent = false
        
        
        viewControllers = [homeNavController, searchNavController, uploadPhotoController, likeNavController, userProfileNavController]
        
        //after setting up controllers we are trying to modify tabbaritems inset postion
        guard let items = tabBar.items else {return}
        for itemX in items {
            //            itemX.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            itemX.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
            
            
        }
    }
    
    
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
        
        
        
    }

}
