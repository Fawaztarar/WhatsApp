//
//  TextInputArea.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 02/05/2024.
//

import SwiftUI

struct TextInputArea: View {
    @State private var text = ""

    var body: some View {
        HStack(alignment: .bottom,spacing: 5 ){
            imagePickerButton()
                .padding(3)
            audioRecorderButton()
            messsageTextField()
            sendMessageButton()

        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top,10)
        .background(.whatsAppWhite)
        
    }
private func messsageTextField() -> some View {
    TextField("", text: $text, axis: .vertical)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.thinMaterial)
        )
        .overlay(textViewBorder())
        
}
private func textViewBorder() -> some View {
    RoundedRectangle(cornerRadius: 20, style: .continuous)
        .stroke(Color(.systemGray5), lineWidth: 1)  
}


private func imagePickerButton() -> some View {
    Button {
        
    } label: {
        Image(systemName: "photo.on.rectangle")
            .font(.system(size: 22))
    }
}

private func audioRecorderButton() -> some View {
    Button {
        
    } label: {
        Image(systemName: "mic.fill")
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .padding(6)
            .background(Color.blue)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}
private func sendMessageButton() -> some View {
    Button {
        
    } label: {
        Image(systemName: "arrow.up")
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .padding(6)
            .background(Color.blue)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
}
}

}


#Preview {
    TextInputArea()
}
