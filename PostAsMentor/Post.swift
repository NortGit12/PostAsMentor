//
//  Post.swift
//  PostAsMentor
//
//  Created by Jeff Norton on 10/18/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

struct Post {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    let identifier: UUID
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    private let identifierKey = "identifier"
    private let textKey = "text"
    private let timestampKey = "timestamp"
    private let usernameKey = "username"
    
    var endpoint: URL? {
        
        guard let extendedURL = PostController.baseURL?.appendingPathComponent(self.identifier.uuidString)
            else { return nil }
        return extendedURL.appendingPathExtension("json")
    }
    
    var jsonValue: [String : Any] {
        
        return [identifierKey: self.identifier.uuidString
            , textKey: self.text
            , timestampKey: self.timestamp
            , usernameKey: self.username
        ]
    }
    
    var jsonData: Data? {
        
        return try? JSONSerialization.data(withJSONObject: jsonValue, options: .prettyPrinted)
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, identifier: UUID = UUID()) {
        
        self.identifier = identifier
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
    
    init?(identifier: String, dictionary: [String : Any]) {
        
        guard let uuid = UUID(uuidString: identifier)
            , let text = dictionary[textKey] as? String
            , let timestamp = dictionary[timestampKey] as? TimeInterval
            , let username = dictionary[usernameKey] as? String
            else {
                
                NSLog("Error: Could not extract all of the post values from the dictionary for post initialization.")
                return nil
        }
        
        self.identifier = uuid
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
