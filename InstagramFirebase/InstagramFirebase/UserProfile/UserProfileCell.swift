//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Christophe Bugnon on 10/09/2018.
//  Copyright © 2018 Christophe Bugnon. All rights reserved.
//

import UIKit
import LBTAComponents

class UserProfileCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: postImageUrl)
        }
    }
    
    let photoImageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
