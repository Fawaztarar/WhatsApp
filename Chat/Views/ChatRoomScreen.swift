//
//  ChatRoomScreen.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 02/05/2024.
//

import SwiftUI

struct ChatRoomScreen: View {
    var body: some View {
        MessageListView()
    
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            leadingNavItems()
            trailingNavItems()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}
    
extension  ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
               Circle()
                .frame(width: 35, height: 35)
            
                Text("User x2")
                    .font(.title2)
                    .bold()
            }       
                
         }
    }
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
            } label: {
                Image(systemName: "video") 
            }
            Button {
            } label: {
                Image(systemName: "phone") 
            }
        }
                
    }
}


#Preview {
    NavigationStack {
        ChatRoomScreen()
    }
}
