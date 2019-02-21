//
//  EditProfileController.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/28/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import UIKit
import Firebase
class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Edit Settings"
        
        setupviews()
        fetchUser()
        setupNavItems()
    }
    
    var user: Users? {
        didSet {
            guard let profileImageUrlString = user?.userProfileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrlString)
            
            nameTextField.text = user?.userFullname
            userNameTextField.text = user?.userFullname
            editEmailTf.text = user?.userEmail
            
            
        }
    }
    
    var selectedImage: UIImage?
    
    lazy var profileImageView: CustomImageView = {
        let images = CustomImageView()
        images.backgroundColor = .red
        images.clipsToBounds = true
        images.layer.masksToBounds = true
        images.contentMode = .scaleAspectFill
        images.translatesAutoresizingMaskIntoConstraints = false
        images.layer.cornerRadius = 100 / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePickPhoto))
        images.addGestureRecognizer(tapGesture)
        images.isUserInteractionEnabled = true
        return images
    }()
    
    lazy var changeProfilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePickPhoto), for: .touchUpInside)
        return button
    }()
    
    let topLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let bottomLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        return label
    }()
    
    let WebsiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website"
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        return tf
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        return tf
    }()
    
    let websiteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Website"
        return tf
    }()
    
    let bioTextView: UITextView = {
        let tf = UITextView()
        tf.text = "Bio"
        tf.isScrollEnabled = false
        return tf
    }()
    
    
    let tryInstagramBusinessTools: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Instagram Business Tools", for: .normal)
        return button
    }()
    
    
    let lineBelowTryBusinessTools: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let privateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Information"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        return label
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        return label
    }()
    
    
    let editEmailTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    let phoneNumberTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        return tf
    }()
    
    let genderTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Gender"
        return tf
    }()
    
    
    @objc func handlePickPhoto() {
        print("Picking photo")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = editedImage
            selectedImage = editedImage
            handleDismiss()
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = originalImage
            selectedImage = originalImage
            handleDismiss()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        handleDismiss()
    }
    
    func fetchUser() {
        guard let currentLogggedInUserUid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("user").child(currentLogggedInUserUid)
            ref.observe(.value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            self.user = Users(uid: currentLogggedInUserUid, dictionary: userDictionary)
        }) { (err) in
            print("Failed to get user", err.localizedDescription)
        }
        
    }
    
    func updateInforToStorage() {
        //remove current profileImage from storage and add the new one
        guard let currentPhoto = user?.userProfileImageUrl else {return}
        Storage.storage().reference(forURL: currentPhoto).delete { (error) in
            if let error = error {
                print("Failed to delete current profilePhoto from DB Storage:", error.localizedDescription)
                
            }
            //successfully removed change pic from storage
            let filename = NSUUID().uuidString
            guard let uploadData = self.selectedImage else {return}
            guard let data = UIImageJPEGRepresentation(uploadData, 0.3) else {return}
            Storage.storage().reference().child("profileImages").child(filename).putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Failed to upload profileImage to Storage:", error?.localizedDescription ?? "")
                    return
                }
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
                self.updateInfoToDatabase(imageUrl: imageUrl)
                self.postNotifications()
            }
            
        }
     
    }
    
    func updateInfoToDatabase(imageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("user").child(uid).child("userProfileImageUrl").setValue(imageUrl) { (error, response) in
            if let error = error {
                print("Failed to upload userProfileImageUrl to database:", error.localizedDescription)
            }
            print("Successfully upload userProfileImageUrl to DB")
        }
    }
    
    fileprivate func setupNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleFinishedEditing))
        
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //updates user profile controller UI
    func postNotifications() {
        let name: Notification.Name = Notification.Name(rawValue: "UpdateProfile")
        NotificationCenter.default.post(name: name, object: self, userInfo: nil)
    }
    
    @objc func handleFinishedEditing() {
        updateInforToStorage()
        handleDismiss()
    }
    
    func setupviews() {
        
        
        let stackview = UIStackView(arrangedSubviews: [nameTextField, userNameTextField, websiteTextField])
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        
        view.addSubview(profileImageView)
        view.addSubview(changeProfilePhotoButton)
        view.addSubview(topLineSeperatorView)
        view.addSubview(nameLabel)
        view.addSubview(userNameLabel)
        view.addSubview(WebsiteLabel)
        view.addSubview(bioLabel)
        view.addSubview(nameTextField)
        view.addSubview(userNameTextField)
        view.addSubview(websiteTextField)
        view.addSubview(bioTextView)
        view.addSubview(bottomLineSeperatorView)
        view.addSubview(tryInstagramBusinessTools)
        view.addSubview(lineBelowTryBusinessTools)
        view.addSubview(privateInfoLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(genderLabel)
        view.addSubview(editEmailTf)
        view.addSubview(phoneNumberTf)
        view.addSubview(genderTf)
        
        
        profileImageView.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        changeProfilePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        changeProfilePhotoButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        topLineSeperatorView.anchor(top: changeProfilePhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        nameLabel.anchor(top: topLineSeperatorView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 0)
        
        userNameLabel.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 0)
        
        WebsiteLabel.anchor(top: userNameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 0)
        
        bioLabel.anchor(top: WebsiteLabel.bottomAnchor, left: userNameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 0)
        
        
        
        
        nameTextField.anchor(top: nameLabel.topAnchor, left: userNameLabel.rightAnchor, bottom: nameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 2, width: 0, height: 0)
        
        userNameTextField.anchor(top: userNameLabel.topAnchor, left: userNameLabel.rightAnchor, bottom: userNameLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        websiteTextField.anchor(top: WebsiteLabel.topAnchor, left: userNameLabel.rightAnchor, bottom: WebsiteLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        bioTextView.anchor(top: bioLabel.topAnchor, left: userNameLabel.rightAnchor, bottom: bioLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        bottomLineSeperatorView.anchor(top: bioTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        tryInstagramBusinessTools.anchor(top: bottomLineSeperatorView.bottomAnchor, left: bioLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        
        
        lineBelowTryBusinessTools.anchor(top: tryInstagramBusinessTools.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        privateInfoLabel.anchor(top: lineBelowTryBusinessTools.bottomAnchor, left: bioLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 18)
        
        emailLabel.anchor(top: privateInfoLabel.bottomAnchor, left: privateInfoLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        phoneLabel.anchor(top: emailLabel.bottomAnchor, left: emailLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
        
        genderLabel.anchor(top: phoneLabel.bottomAnchor, left: phoneLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        editEmailTf.anchor(top: emailLabel.topAnchor, left: emailLabel.rightAnchor, bottom: emailLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        phoneNumberTf.anchor(top: phoneLabel.topAnchor, left: phoneLabel.rightAnchor, bottom: phoneLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        genderTf.anchor(top: genderLabel.topAnchor, left: genderLabel.rightAnchor, bottom: genderLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
