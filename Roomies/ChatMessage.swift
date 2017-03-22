//
//  ChatMessage.swift
//  Roomies
//
//  Created by Cameron Moreau on 3/22/17.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class ChatMessage: NSObject {
    
    var text: String
    var sender: String
    var date: Date
    
    convenience init(text: String?, sender: String?) {
        self.init(text: text, sender: sender, date: nil)
    }
    
    init(text: String?, sender: String?, date: Date?) {
        self.text = text ?? ""
        self.sender = sender ?? "unknown"
        self.date = date ?? Date()
    }
}
