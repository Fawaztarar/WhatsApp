//
//  ChatPartnerPickerViewModel.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 08/05/2024.
//

import Foundation
import Firebase

enum ChannelCreationRoute {
   case groupPartnerPicker
   case setupGroupChat
}

enum ChannelContants {
    static let maxGroupMembers = 12
}

enum ChannelCreationError: Error {
    case noChatPartner
    case failedToCreateUniqueIds 
}

@MainActor 
final class ChatPartnerPickerViewModel: ObservableObject {
      @Published var navStack = [ChannelCreationRoute]()
      @Published var selectedChatPartners = [UserItem]()
      @Published private(set) var users = [UserItem]()
      @Published var errorState:(showError: Bool, errorMessage: String) = (false, "Uh ho")

      private var lastCursor: String?

      var showSelectedUsers: Bool {
          return !selectedChatPartners.isEmpty
      }

      var disableNextButton: Bool {
          return selectedChatPartners.isEmpty
      }

      var isPaginatable: Bool {
          return !users.isEmpty
      }

      private var isDirectChannel: Bool {
          return selectedChatPartners.count == 1
      } 

      init() {
          Task {
              await fetchUsers()
          }
      }
     
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid }
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
            
            print("lastCursor: \(String(describing: lastCursor)) \(users.count)")

        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }

      func deSelectAllChatPartners() {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              self.selectedChatPartners.removeAll()    
                }
      }

      func handleItemSelection(_ item: UserItem) {
          if isUserSelected(item) {
             guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else { return }
               selectedChatPartners.remove(at: index)
            } else {
                guard selectedChatPartners.count < ChannelContants.maxGroupMembers else {
                    let errorMessage = "Sorry you can only add up to \(ChannelContants.maxGroupMembers) members in a group chat."
                    showError(errorMessage)
                    return
                }
               selectedChatPartners.append(item)
            }
      }

        
    func isUserSelected(_ user: UserItem) -> Bool {
          let isSelected = selectedChatPartners.contains { $0.uid == user.uid }
            return isSelected
      }


    func createDirectChannel(_ chatPartner: UserItem, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        selectedChatPartners.append(chatPartner)
        
        Task {
            if let channelId = await verifyIfDirectChannelExists(with: chatPartner.uid) {
                let snapshot = try await FirebaseConstants.ChannelsRef.child(channelId).getData()
                let channelDict = snapshot.value as! [String: Any]
                var directChannel = ChannelItem(channelDict)
                directChannel.members = selectedChatPartners
                completion(directChannel)
            } else {
                let channelCreation = createChannel(nil)
                switch channelCreation {
                case .success(let channel):
                    completion(channel)
                case .failure(let failure):
                    showError("Sorry, something went wrong. Please try again.")
                    print("Failed to create a Direct Channel: \(failure.localizedDescription)")
                    
                }
            }
        }
    }

    typealias ChannelId = String

    private func verifyIfDirectChannelExists(with chatPartnerId: String) async -> ChannelId? {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let snapshot = try? await FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartnerId).getData(),
            snapshot.exists()
            else { return nil }

            let directMessageDict = snapshot.value as! [String: Bool]
            let channelId = directMessageDict.compactMap { $0.key }.first
            return channelId

        }
    


    func createGroupChannel(_ groupName: String?, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
    let channelCreation = createChannel(groupName)

    switch channelCreation {
    case .success(let channel):
        completion(channel)

    case .failure(let error):
        showError("Sorry, something went wrong. Please try again.")

        print("Failed to create a Group Channel: \(error.localizedDescription)")
    }
}
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
      
    

    private func createChannel(_ channelName: String?) ->  Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else {
            return .failure(ChannelCreationError.noChatPartner)
        }
        guard
            let channelId = FirebaseConstants.ChannelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid,
            let messageId = FirebaseConstants.MessagesRef.childByAutoId().key

        else {  return .failure(ChannelCreationError.failedToCreateUniqueIds) }

        let timeStamp = Date().timeIntervalSince1970
        var membersUids = selectedChatPartners.compactMap { $0.uid }
        membersUids.append(currentUid)

        let newChannelBroadcast = AdminMessageType.channelCreation.rawValue 

        var channelDict: [String: Any] = [
            .id: channelId,
            .lastMessage: newChannelBroadcast,
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .membersUids: membersUids,
            .membersCount: membersUids.count,
            .adminUids: [currentUid],
            .createdBy: currentUid
        ]

        if let channelName = channelName, !channelName.isEmptyOrWhitespace {
            channelDict[.name] = channelName
        }
        let messageDict: [String: Any] = [
            .type: newChannelBroadcast,
            .timeStamp: timeStamp,
            .ownerUid: currentUid
        ]

        FirebaseConstants.ChannelsRef.child(channelId).setValue(channelDict)
        FirebaseConstants.MessagesRef.child(channelId).child(messageId).setValue(messageDict)

        membersUids.forEach { userId in
            FirebaseConstants.UserChannelRef.child(userId).child(channelId).setValue(true)  
        }

        if isDirectChannel {
            let chatPartner = selectedChatPartners[0]
            FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartner.uid).setValue([channelId: true])
            FirebaseConstants.UserDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }

        var newChannelItem = ChannelItem(channelDict)
        newChannelItem.members = selectedChatPartners
         return .success(newChannelItem)

    }
}

