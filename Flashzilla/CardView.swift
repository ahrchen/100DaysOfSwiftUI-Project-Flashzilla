//
//  CardView.swift
//  Flashzilla
//
//  Created by Raymond Chen on 4/13/22.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    let card: Card
    let removal: ((Bool) -> Void)?
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .cardBackground(offset)

                
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width < 0 {
                            feedback.notificationOccurred(.error)
                            removal?(false)
                        } else {
                            removal?(true)
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}

struct CardBackground: ViewModifier {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    var offset: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                differentiateWithoutColor
                ? nil
                :
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(getCardColor(offset: offset))
                )
            .shadow(radius: 10)
    }
    
    func getCardColor(offset: CGSize) -> Color  {
        if offset.width >= 0 {
            if offset.width == 0 {
                return Color.white
            } else {
                return Color.green
            }
        } else {
            return Color.red
        }
    }
}

extension View {
    func cardBackground(_ offset: CGSize) -> some View {
        modifier(CardBackground(offset: offset))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example, removal: nil)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
