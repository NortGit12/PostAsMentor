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
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, identifier: UUID = UUID()) {
        
        self.identifier = identifier
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
    
    init?(dictionary: [String : Any]) {
        
        guard let identifier = dictionary[identifierKey] as? UUID
            , let text = dictionary[textKey] as? String
            , let timestamp = dictionary[timestampKey] as? TimeInterval
            , let username = dictionary[usernameKey] as? String
            else {
                
                NSLog("Error: Could not extract all of the post values from the dictionary for post initialization.")
                return nil
        }
        
        self.identifier = identifier
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
