//
//  User.swift
//  Roomies
//
//  Created by Cameron Moreau on 2/24/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

class User {

    var id: String
    var name: String
    var email: String?
    var avatarUrl: String?
    
    init(id: String, name: String?, email: String?, avatarUrl: String?) {
        self.id = id
        self.name = name ?? "No name"
        self.email = email
        self.avatarUrl = avatarUrl
    }
}
