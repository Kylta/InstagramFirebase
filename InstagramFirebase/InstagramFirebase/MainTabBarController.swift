//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 08/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                return
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }

}
