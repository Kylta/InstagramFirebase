//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 08/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import LBTAComponents
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusPhotoButton: UIButton = {
        let button = UIButton.systemButton(title: nil, image: #imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), titleColor: nil, font: nil, target: self, selector: #selector(handlePlusPhoto))
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton.systemButton(title: "Sign Up", image: nil, titleColor: .white, font: UIFont.boldSystemFont(ofSize: 14), target: self, selector: #selector(handleSignUp))
        button.backgroundColor = UIColor.init(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderWidth = 1
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        //        if isFormValid {
        //            signUpButton.backgroundColor = UIColor.init(r: 17, g: 154, b: 237)
        //        } else {
        //            signUpButton.backgroundColor = UIColor.init(r: 149, g: 204, b: 244)
        //        }
        
                _ = isFormValid ? (signUpButton.backgroundColor = UIColor.init(r: 17, g: 154, b: 237), signUpButton.isEnabled = true) : (signUpButton.backgroundColor = UIColor.init(r: 149, g: 204, b: 244), signUpButton.isEnabled = false)
        
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0, let username = usernameTextField.text, username.count > 0, let password = passwordTextField.text, password.count > 0 else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to register user:", err)
            }
            print("Successfully created user:", user?.user.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                storageRef.downloadURL(completion: { (downloadUrl, err) in
                    if let err = err {
                        print("Failed to get url profile image", err)
                    }
                    guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    guard let uid = user?.user.uid else { return }
                    
                    let dictionaryValues = ["username":username, "profileImageUrl":profileImageUrl]
                    let values = [uid:dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user into database:", err)
                            return
                        }
                        print("Successfully saved user into database")
                    })
                    
                })
            })
        }
    }
    
    fileprivate func setupViews() {
        
        let stackFieldViews = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackFieldViews.distribution = .fillEqually
        stackFieldViews.axis = .vertical
        stackFieldViews.spacing = 10
        
        [plusPhotoButton, stackFieldViews].forEach({view.addSubview($0)})
        
        plusPhotoButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 140)
        plusPhotoButton.anchorCenterXToSuperview()
        
        stackFieldViews.anchor(plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 200)
    }
    
}

