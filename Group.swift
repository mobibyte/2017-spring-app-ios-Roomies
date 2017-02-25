//
//  Group.swift
//  
//
//  Created by Cameron Moreau on 2/24/17.
//
//

class Group {
    
    var id: String!
    var joinKey: String!
    var members: [User]?
    
    init(id: String, joinKey: String) {
        self.id = id
        self.joinKey = joinKey
    }
}
