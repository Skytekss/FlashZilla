//
//  CardView.swift
//  FlashZilla
//
//  Created by Илья Гринько on 29.11.2024.
//

import SwiftUI

struct CardView: View {
  @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
  
  @State private var isShowingAnswer = false
  @State private var offset = CGSize.zero
  
  let card: Card
  
  var removal: (() -> Void)? = nil
  
  var body: some View {
    ZStack {
      cardBody
      
      cardContent
    }
    .frame(width: Sizes.cardFrameWidth, height: Sizes.cardFrameHeight)
    .rotationEffect(.degrees(offset.width / Sizes.cardRotationDegrees))
    .offset(x: offset.width * Sizes.cardOffsetMultiple)
    .opacity(Sizes.cardOpacityMain - Double(abs(offset.width / Sizes.cardOpacityDegrees)))
    .gesture(
      cardGesture
    )
    .onTapGesture {
      isShowingAnswer.toggle()
    }
  }
  
  // MARK: VIEWS
  
  var cardBody: some View {
    RoundedRectangle(cornerRadius: Sizes.cardRectangleCornerRadius)
      .fill(
        accessibilityDifferentiateWithoutColor
        ? .white
        : .white.opacity(Sizes.cardOpacityFillMain - Double(abs(offset.width / Sizes.cardOpacityDegrees)))
      )
      .background(
        accessibilityDifferentiateWithoutColor
        ? nil
        : RoundedRectangle(cornerRadius: Sizes.cardRectangleCornerRadius)
          .fill(offset.width > 0 ? .green : .red)
      )
      .shadow(radius: Sizes.cardRectangleShadowRadius)
  }
  
  var cardContent: some View {
    VStack {
      Text(card.prompt)
        .font(.largeTitle)
        .foregroundStyle(.black)
      
      if isShowingAnswer {
        Text(card.answer)
          .font(.title)
          .foregroundStyle(.secondary)
      }
    }
    .padding()
    .multilineTextAlignment(.center)
  }
  
  var cardGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        offset = gesture.translation
      }
      .onEnded { _ in
        if abs(offset.width) > Sizes.cardDragMaxPoint {
          removal?()
        } else {
          offset = .zero
        }
      }
  }
  
  private struct Sizes {
    static let cardRectangleCornerRadius: CGFloat = 24
    static let cardRectangleShadowRadius: CGFloat = 8
    static let cardFrameWidth: CGFloat = 600
    static let cardFrameHeight: CGFloat = 300
    static let cardRotationDegrees: CGFloat = 5
    static let cardOffsetMultiple: CGFloat = 5
    static let cardOpacityMain: CGFloat = 2
    static let cardOpacityFillMain: CGFloat = 1
    static let cardOpacityDegrees: CGFloat = 50
    static let cardDragMaxPoint: CGFloat = 100
  }
}

#Preview {
  CardView(card: .example)
}
