//
//  BubbleTextView.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 02/05/2024.
//

import SwiftUI

struct BubbleTextView: View {
    let item: MessageItem
    

    var body: some View {
        VStack(alignment: item.HorizontalAlignment, spacing: 3) {
        Text("Salam Kia hal hai Janab ")
            .padding(10)
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)

         timeStampTextView()
    }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .received ? 5 : 100)
        .padding(.trailing, item.direction == .received ? 100 : 5)

}
    private func timeStampTextView() -> some View {
        HStack {
            
            Text("12:00 PM")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color(.systemBlue))
                    
                
                
            }
            
        }
    }
}



#Preview {
    ScrollView{
        BubbleTextView(item: .sentplaceholder)
        BubbleTextView(item: .receivedplaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.4))
}
 
