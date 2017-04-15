//
//  ChatViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 10/28/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    
    var messagesRef: FIRDatabaseReference!
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    
    var messages = [JSQMessage]()
    
    let factory = JSQMessagesBubbleImageFactory()
    
    var outBubble: JSQMessagesBubbleImage!
    var inBubble: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseViewControllerUtil.setup(viewController: self)
        
        // Load messages
        self.messagesRef = FIRDatabase.database().reference().child("groups/\(localGroup.id)/messages")
        self.messagesRef.queryLimited(toLast: 50).observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value as? Dictionary ?? [:]

            let text = data["text"] as? String
            let sender = data["sender"] as? String
            let message = JSQMessage(senderId: sender, displayName: "uhh", text: text)
            
            if let message = message {
                self.messages.append(message)
                self.finishReceivingMessage()
            }
        })
        
        self.senderId = "self"
        self.senderDisplayName = "test"
        
        self.outBubble = factory?.outgoingMessagesBubbleImage(with: UIColor.chatBlue)
        self.inBubble = factory?.outgoingMessagesBubbleImage(with: UIColor.chatGray)
        
        print("people involved in group")
        print(localGroup.members)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return self.outBubble
        } else {
            return self.inBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        sendMessage(text: text, sender: self.senderId)
        
        self.finishSendingMessage(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "We're not there yet", message: "Cant attach stuff yet, sorry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Utils
    func sendMessage(text: String, sender: String) {
        self.messagesRef.childByAutoId().setValue([
            "text": text,
            "sender": sender
            ])
        print("SENDING WITH GROUP \(localGroup.id)")
    }
}
