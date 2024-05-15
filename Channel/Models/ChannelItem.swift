//
//  ChannelItem.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 10/05/2024.
//

import Foundation
import Firebase

struct ChannelItem: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: Int
    var adminUids: [String]
    var membersUids: [String]
    var members: [UserItem]
    var thumbnailUrl: String?
    let createdBy: String  
    
    // Computed property to determine if it's a group chat
    var isGroupChat: Bool {
        return membersCount > 2
    }

    var membersExcludeCurrentUser: [UserItem] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        return members.filter { $0.uid != currentUid }
    }   

    var title : String {
       if let name = name {
           return name
       } 

       if isGroupChat {
           return groupMemberNames
       } else {
           return membersExcludeCurrentUser.first?.username ?? "Unknown"
       }
    }
    private var groupMemberNames: String {
        let membersCount = membersCount - 1
        let fullNames = membersExcludeCurrentUser.map { $0.username }  

        if membersCount == 2 {
            // username1 and username2
            return fullNames.joined(separator: " and ")
        } else if membersCount > 2 {
            // username1, username2, and 10 others
            let remainingCount = membersCount - 2
            return fullNames.prefix(2).joined(separator: ", ") + ", and \(remainingCount) others"
        }

        return "Unknown"
    }

    
    
    static let placeholder = ChannelItem.init(id: "1", lastMessage: "Hello", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], membersUids: [], members: [], thumbnailUrl: nil, createdBy: "")
}


extension ChannelItem {
    init(_ dict: [String: Any]) {
        // Safe extraction of values from dictionary using appropriate keys and providing default values
        self.id = dict[.id] as? String ?? ""
        self.name = dict[.name] as? String ?? nil
        self.lastMessage = dict[.lastMessage] as? String ?? ""
        
        let creationInterval = dict[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)
        
        let lastMsgTimeStampInterval = dict[.lastMessageTimeStamp] as? Double ?? 0
        self.lastMessageTimeStamp = Date(timeIntervalSince1970: lastMsgTimeStampInterval)
        
        self.membersCount = dict[.membersCount] as?  Int ?? 0
        self.adminUids = dict[.adminUids] as? [String] ?? []
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.membersUids = dict[.membersUids] as? [String] ?? []
        self.members = dict[.members] as? [UserItem] ?? []
        self.createdBy = dict[.createdBy] as? String ?? ""
    }
}


extension String{
    static let id = "id"
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let creationDate = "creationDate"
    static let lastMessageTimeStamp = "lastMessageTimeStamp"
    static let membersCount = "membersCount"
    static let adminUids = "adminUids"
    static let membersUids = "membersUids"
    static let thumbnailUrl = "thumbnailUrl"
    static let members = "members"
    static let createdBy = "createdBy"
    
}
