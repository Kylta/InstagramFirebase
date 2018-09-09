//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 09/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import LBTAComponents

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("You don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(signUpButton)
        signUpButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)

    }
    
    @objc func handleShowSignUp() {
        print("Handle sign up button")
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }

}
