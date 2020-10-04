//
//  ProductViewModelTests.swift
//  NateiOSChallengeTests
//
//  Created by Francesca Palese on 03/10/2020.
//

import XCTest
@testable import NateiOSChallenge

class PostViewModelTests: XCTestCase {

    var sut: PostsViewModel!
    
    var posts: [Post]?
    
    fileprivate var mockAPIService: MockApiService!
    
    override func setUp() {
        
        super.setUp()
        mockAPIService = MockApiService()
        sut = PostsViewModel()
        sut = PostsViewModel(apiService: mockAPIService)
        
    }
    
    override func tearDown() {
        sut = nil
        posts = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    //    MARK: - Init
    func testInit() {
        sut = PostsViewModel()
        
        XCTAssertNotNil(sut)
    }
    
//    MARK: - Init
    func testInitWithFoodItem_FoodItemNotNil() {
        
        initWithPosts()
        
        XCTAssertNotNil(sut.posts)
    }
    
    private func initWithPosts() {
        
        posts = StubGenerator.stubProductsResponse().posts
        
        sut = PostsViewModel(posts: posts!)
        
    }
    
//MARK: - Fetch Posts
    
    func testFetchPosts_FetchPostsCalled() {
        
        
        sut.fetchPosts { result in
            switch result {
            case .success:
                print("posts fetched")
            case . failure:
                print("error while fetching posts")
                
            }
        }
        XCTAssert(mockAPIService!.postsFetched)

    }
    
    
    
}

// MARK: - MockApiService
fileprivate class MockApiService: APIServiceProtocol {

    
    
    var completionResponse: PostsResponse? //stub
    
    var completionClosure: ((Result<PostsResponse, APIServiceError>) -> Void)!
    
    var postsFetched = false
    
    func fetchPosts(with request: PostsRequest?, completion: @escaping ((Result<PostsResponse, APIServiceError>) -> Void)) {
        postsFetched = true
        completionClosure = completion
    }
    
//    TODO: implement func
    func createPost(with request: CreatePostRequest?, completion: @escaping ((Result<CreatePostResponse, APIServiceError>) -> Void)) {
        print("created")
    }
    
    
    
    func fetchSuccess() {
        completionClosure(Result.success(completionResponse!))
        
    }
    
    func fetchFail(error: APIServiceError?) {
        
        completionClosure(Result.failure(error!))
        
    }
    
}

//MARK: StubGenerator

class StubGenerator {
    
    public init() {
        
    }
    
    static func stubProductsResponse() -> PostsResponse {
        let post1 = Post(id: "Test1", createdAt: "1234", updatedAt: "1234", product: Product(title: "Test1", images: [], url: "test1.com", merchant: "Test1"))
        let post2 = Post(id: "Test1", createdAt: "5678", updatedAt: "5678", product: Product(title: "Test2", images: [], url: "test2.com", merchant: "Test2"))
        return PostsResponse(posts: [post1, post2])
        
    }
    
    
}

