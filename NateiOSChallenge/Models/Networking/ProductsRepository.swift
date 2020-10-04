//
//  ProductsRepository.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import Foundation

protocol APIServiceProtocol: class {
    
    func fetchPosts(with request: PostsRequest?, completion: @escaping ((Result<PostsResponse, APIServiceError>) -> Void))
    func createProduct(with product: CreateProductRequest, completion: @escaping ((Result<CreateProductResponse, APIServiceError>) -> Void))
}

// Enum of Errors
public enum APIServiceError: Error {
    case apiError // 0
    case invalidEndpoint // 1
    case invalidResponse // 2
    case noData // 3
    case decodeError // 4
}

enum HTTPMethod: String {
    case GET
    case POST
}

struct Endpoint {
    var path: String
    var verb: HTTPMethod
}
