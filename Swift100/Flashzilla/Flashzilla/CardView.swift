//
//  CardView.swift
//  Flashzilla
//
//  Created by liqiang on 2024/6/14.
//

import SwiftUI

struct CardView: View {
    let card:Card
    var removal:(()->Void)? = nil
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor ? nil :
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            VStack {
                Text(card.promot)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
                
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450,height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x:offset.width * 5)
        .opacity(2-Double(abs(offset.width/50)))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    offset = gesture.translation
                })
                .onEnded({ _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    }else {
                        offset = .zero
                    }
                })
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

#Preview {
    CardView(card: .example)
}
