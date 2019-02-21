//
//  CC+ImagePickerDelegate.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/19/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
//extension CameraController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            setupStoriesUI()
//            
//            
//            selectedImage.image = originalImage
//            capturePhotoButton.isHidden = true
//            dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    
//    func setupStoriesUI() {
//        view.addSubview(selectedImage)
//        selectedImage.addSubview(uploadStoriesButton)
//        selectedImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//
//        uploadStoriesButton.anchor(top: nil, left: nil, bottom: selectedImage.bottomAnchor, right: selectedImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 120, height: 50)
//        uploadStoriesButton.layer.cornerRadius = 22
//    }
//    
//    
//    @objc func handleUploadStoriesToDatabaseStorage() {
//        let filename = NSUUID().uuidString
//        guard let selectedPhoto = selectedImage.image else {return}
//        guard let uploadData = UIImageJPEGRepresentation(selectedPhoto, 0.8) else {return}
//            Storage.storage().reference().child("stories_images").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
//                if let error = error {
//                    print("failed to upload stories to DB Storage:", error.localizedDescription)
//                    return
//                }
//                guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
//                self.uploadStoriesToDB(imageUrl: imageUrl)
//        }
//        
//        
//        
//    }
//    
//    func uploadStoriesToDB(imageUrl: String) {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let ref = Database.database().reference().child("stories").child(uid)
//        let storiesId = ref.childByAutoId().key
//        let values: [String:Any] = ["imageUrl": imageUrl, "id": storiesId]
//        ref.child(storiesId).updateChildValues(values) { (error, response) in
//            if error != nil {
//                print("failed to upload stories to Database:", error?.localizedDescription ?? "")
//            }
//            let tabbarController = MainTabBarController()
//            self.present(tabbarController, animated: true, completion: nil)
//            
//        }
//    }
//    
//    
//    
//}
