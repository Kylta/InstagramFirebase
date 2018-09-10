//
//  Post.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 10/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
