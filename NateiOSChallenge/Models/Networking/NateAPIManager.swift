//
//  NateAPIManager.swift
//  nate.ios.challenge.
//
//  Created by Francesca Palese on 28/09/2020.
//

import Foundation

public class NateAPIManager: APIServiceProtocol {
    
    //    MARK: - Singleton
    
    public static let shared = NateAPIManager()
    
    private init() { }
    private let urlSession = URLSession.shared
    
    private var basePath = "http://localhost:3000"
    

    func fetchPosts(with request: PostsRequest?, completion: @escaping ((Result<PostsResponse, APIServiceError>) -> Void)) {
        
        guard let endpoint = request?.resource() else { return }
        
        let path = basePath + endpoint.path
        let data = try? JSONEncoder().encode(request)
        
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = endpoint.verb.rawValue
        request.allHTTPHeaderFields = ["content-type": "application/json"]
        request.httpBody = (data ?? Data()) as Data

        urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
               
                let response = try JSONDecoder().decode(PostsResponse.self, from: jsonData)
                completion(Result.success(response))
            } catch {
                completion(.failure(.decodeError))
                return
            }
        }).resume()
    }
    
//    TODO: refactor this func
    func createPost(with request: CreatePostRequest?, completion: @escaping ((Result<CreatePostResponse, APIServiceError>) -> Void)) {
        
        guard let endpoint = request?.resource() else { return }
        let path = basePath + endpoint.path

//        let path = "http://localhost:3000/product/create"
//
        let data = try? JSONEncoder().encode(request)
        print(data as? String)

        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = endpoint.verb.rawValue
        request.allHTTPHeaderFields = ["content-type": "application/json"]
        request.httpBody = data! as Data


        urlSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let response = try JSONDecoder().decode(CreatePostResponse.self, from: jsonData)
                completion(Result.success(response))
            } catch {
                completion(.failure(.decodeError))
                return
            }
        }).resume()
    }
    
}
