//
//  ProductsViewModel.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import Foundation
import UIKit

class PostsViewModel {
    
    public var posts = [Post]()
    public var currentFetchedPosts = [Post]()
    
    private var apiService: APIServiceProtocol
    private var isFetchInProgress = false
    private var totalItems = 0

    private var skip = 0
    private var take = 20
    
    init(posts: [Post], apiService: APIServiceProtocol = NateAPIManager.shared) {
        self.posts = posts
        self.apiService = apiService
    }
    
    public init(apiService: APIServiceProtocol = NateAPIManager.shared) {
        self.apiService = apiService
    }
    
//   MARK: - View Properties

    var totalProducts: Int {
        return posts.count
    }
    
    
    func product(at index: Int) -> Post? {
        return posts[index]
    }
    
    func fetchPosts(completion: @escaping ((Result<PostsViewModel, Error>) -> Void)) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        let request = PostsRequest(skip: skip, take: take)
        
        apiService.fetchPosts(with: request) { result in
            
            switch result {
            case .success(let response):
                let fetchedPosts = response.posts
                self.posts.append(contentsOf: fetchedPosts)
                self.currentFetchedPosts = fetchedPosts
                let model = PostsViewModel(posts: fetchedPosts)
                
                self.skip += 20
                self.take += 20
                self.isFetchInProgress = false
                completion(Result.success(model))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
//    TODO: complete func
    func createPost(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        let product = Product(title: "prodotto2", images: ["rectangsle"], url: "sskafskal", merchant: "Francesca")
        let request = CreatePostRequest(product: product)
        apiService.createPost(with: request) { result in
                
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
