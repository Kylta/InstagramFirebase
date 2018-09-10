//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 10/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextviews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc fileprivate func handleShare() {
        let filename = UUID().uuidString
        
        guard let caption = textView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (_, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to put data:", err)
                return
            }
            storageRef.downloadURL(completion: { (downloadUrl, err) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to retrieve downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadUrl?.absoluteString else { return }
                print("Successfully upload post image:", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let caption = textView.text else { return }
        guard let postImage = selectedImage else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values: [String:Any] = ["imageUrl":imageUrl, "caption":caption, "imageWidth":postImage.size.width, "imageHeight":postImage.size.height, "creationDate":Date().timeIntervalSinceReferenceDate]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post to DB:", err)
                return
            }
            print("Successfully saved info to DB:")
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    fileprivate func setupImageAndTextviews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        [imageView, textView].forEach({containerView.addSubview($0)})
        imageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 84, heightConstant: 0)
        textView.anchor(containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
}
