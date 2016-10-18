//
//  PostController.swift
//  PostAsMentor
//
//  Created by Jeff Norton on 10/18/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

protocol PostControllerDelegate {
    
    func postsUpdated(posts: [Post])
}

class PostController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts")
    static let postEndpoint = baseURL?.appendingPathExtension("json").absoluteString
    
    static var posts = [Post]() {
        
        didSet{
            
            youak?.postsUpdated(posts: posts)
        }
    }
    
    static var youak: PostControllerDelegate?
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init() {
        
        PostController.fetchPosts()
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    static func fetchPosts(completion: ((_ posts: [Post]?) -> Void)? = nil) {
        
        guard let postEndpoint = postEndpoint
            , let url = URL(string: postEndpoint)
            else {
            
                NSLog("Error creating the endpoint for the fetch.")
                
                if let completion = completion {
                    completion(nil)
                }
                
                return
        }
        
        NetworkController.performRequest(for: url, httpMethod: .Get) { (data, error) in
            
            /*
            {
                "-KJlmNiMouUkh78zasXo": {
                    "text": "First Post",
                    "timestamp": 1465419139.598207,
                    "username": "Karl"
                }, ...
            */
            
            guard let data = data
                , let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : [String : Any]]
                else {
                    
                    NSLog("Error serializing JSON")
                    
                    if let completion = completion {
                        completion(nil)
                    }
                    
                    return
            }
            
            let posts = jsonDictionary.flatMap({ Post(identifier: $0.key, dictionary: $0.value) })
            let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            self.posts = sortedPosts
                
            DispatchQueue.main.async {
                
                if let completion = completion {
                    completion(sortedPosts)
                }
            }
        }
    }
}
