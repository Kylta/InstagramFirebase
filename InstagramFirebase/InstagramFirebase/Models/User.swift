//
//  User.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 09/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
