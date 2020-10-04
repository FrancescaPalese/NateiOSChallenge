//
//  ProductDetailViewModel.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 30/09/2020.
//

import Foundation
import UIKit

class ProductDetailViewModel {
    
    var post: Post
    
    var name: String {
        return post.product.title
    }
    
    var merchant: String {
        return post.product.merchant
    }
    
    var urlImage: String? {
        if post.product.images?.count != 0 {
            return post.product.images?[0]
        }
            return nil
    }
    
    var urlLink: String? {
        return post.product.url
    }
    
    init(with post: Post) {
        self.post = post
    }
    
}
