//
//  NateAPIResponse.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import Foundation
import UIKit

//MARK: - ProductsRequest
struct PostsRequest: Encodable {
    var skip: Int
    var take: Int
    
    func resource() -> Endpoint {
        return Endpoint(path: "/products/offset", verb: .POST)
    }
}

//MARK: - ProductsResponse
struct PostsResponse: Decodable {
    let posts: [Post]
}

public struct Post: Decodable, Hashable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let product: Product
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: CodingKey {
      case id, createdAt, updatedAt, title, images, url, merchant
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id =  try container.decode(String.self, forKey: .id)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        let title = try container.decode(String.self, forKey: .title)
        let images = try container.decode([String].self, forKey: .images)
        let url = try container.decode(String.self, forKey: .url)
        let merchant = try container.decode(String.self, forKey: .merchant)
        
        product = Product(title: title, images: images, url: url, merchant: merchant)
    }
    
    init(id: String, createdAt: String, updatedAt: String, product: Product) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.product = product
    }
}

public struct Product: Decodable {
    let title: String
    let images: [String]?
    let url: String
    let merchant: String
}

//MARK: - CreateProductRequest

struct CreateProductRequest: Encodable {
    var title: String
    var images: [String]
    var url: String
    var merchant: String
}

//MARK: - CreateProductResponse

struct CreateProductResponse: Decodable {
    let post: Post
    
    enum CodingKeys: CodingKey {
      case id, createdAt, updatedAt, title, images, url, merchant
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id =  try container.decode(String.self, forKey: .id)
        let createdAt =  try container.decode(String.self, forKey: .createdAt)
        let updatedAt =  try container.decode(String.self, forKey: .updatedAt)
        let title = try container.decode(String.self, forKey: .title)
        let images = try container.decode([String].self, forKey: .images)
        let url = try container.decode(String.self, forKey: .url)
        let merchant = try container.decode(String.self, forKey: .merchant)
        let product = Product(title: title, images: images, url: url, merchant: merchant)
        post = Post(id: id, createdAt: createdAt, updatedAt: updatedAt, product: product)
    }
    
}
