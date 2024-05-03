//
//  BubbleAudioView.swift
//  WhatsApp
//
//  Created by Fawaz Tarar on 03/05/2024.
//

import SwiftUI

struct BubbleAudioView: View {
    let item: MessageItem
    @State private var slideValue: Double = 0
    @State private var sliderRange: ClosedRange<Double> = 0...20

    var body: some View {
        VStack(alignment: item.HorizontalAlignment, spacing: 3) {
            HStack {
            playButton()
            Slider(value: $slideValue , in: sliderRange)
                .tint(.gray)

            Text("06:00")
                .foregroundStyle(.gray)

        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(5)
        .background(item.backgroundColor )
        .clipShape(RoundedRectangle(cornerRadius: 16, style:  .continuous))
        .applyTail(item.direction )
            
        timeStampTextView()
    }
    .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: item.alignment)
    .padding(.leading, item.direction == .received ? 5 : 100)
    .padding(.trailing, item.direction == .received ? 100 : 5)
        
        }

    private func playButton() -> some View {
            Button {
            
            } label: {
            Image(systemName: "play")
                .padding(10)
                .background(item.direction == .received ? .green : .white)
                .clipShape(Circle())
                .foregroundStyle(item.direction == .received ? .white : .black)
         }
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
    ScrollView {
    BubbleAudioView(item: .sentplaceholder)
    BubbleAudioView(item: .receivedplaceholder)
}
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(Color.gray.opacity(0.4))
    .onAppear {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    } 

}

