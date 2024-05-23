//
//  SignUpScreen.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 07/05/2024.
//

import SwiftUI

struct SignUpScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authScreenModel = AuthScreenModel()
    
    var body: some View {
        VStack {
            Spacer()
            AuthHeaderView()
            AuthTextField(type: .email,  text: $authScreenModel.email)
            
            
            
            let usernameType =
            AuthTextField.InputType.custom("Username", "at")
            AuthTextField(type: usernameType,  text: $authScreenModel.username)
            
            AuthTextField(type: .password,  text: $authScreenModel.password)
            
            AuthButton(title: "نیا اکاؤنٹ بنائیں") {
                Task {
                    await authScreenModel.handleSignUp()
                }
                
            }
            .disabled(authScreenModel.disableSignUpButton)
            
            Spacer()
            
            backButton()
                .padding(.bottom, 30)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background{
            LinearGradient(
                gradient: Gradient(colors: [.green, Color.green.opacity(0.8), .teal]),
                startPoint: .top,
                endPoint: .bottom
            )

        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        
    }
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                (
                    Text(" پہلے ہی اکاؤنٹ بنا چکا ہے ؟ ")
                    +
                    Text("Log In").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpScreen()
}
