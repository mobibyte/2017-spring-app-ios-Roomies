//
//  Group.swift
//  
//
//  Created by Cameron Moreau on 2/24/17.
//
//

class Group {
    
    var id: String
    var joinKey: String
    var members: [String:User]
    
    init(id: String, joinKey: String, members: [String:User]) {
        self.id = id
        self.joinKey = joinKey
        self.members = members
    }
}
