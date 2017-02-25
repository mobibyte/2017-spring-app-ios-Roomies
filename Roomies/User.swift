//
//  User.swift
//  Roomies
//
//  Created by Cameron Moreau on 2/24/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

class User {

    var id: String
    var email: String?
    var name: String?
    var avatarUrl: String?
    
    init(id: String) {
        self.id = id
    }
}
