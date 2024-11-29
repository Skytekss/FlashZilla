//
//  ContentView.swift
//  FlashZilla
//
//  Created by Илья Гринько on 29.11.2024.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
  @Environment(\.scenePhase) var scenePhase
  
  @State private var cards = Array<Card>(repeating: .example, count: 10)
  @State private var timeRmaining = 100
  @State private var isActive = true
  
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      LinearGradient(colors: [.black, .gray], startPoint: .bottom, endPoint: .top)
        .ignoresSafeArea()
      
      VStack {
        timerView
        
        ZStack {
          ForEach(0..<cards.count, id: \.self) { index in
            CardView(card: cards[index]) {
              withAnimation {
                removeCard(at: index)
              }
            }
            .stacked(at: index, in: cards.count)
          }
        }
      }
      
      if accessibilityDifferentiateWithoutColor {
        withoutColorAlternativeHelper
      }
    }
    .onReceive(timer) { time in
      guard isActive else { return }
      
      if timeRmaining > 0 {
        timeRmaining -= 1
      }
    }
    .onChange(of: scenePhase) {
      if scenePhase == .active {
        isActive = true
      } else {
        isActive = false
      }
    }
  }
  
  // MARK: VIEWS
  
  var timerView: some View {
    Text("Time: \(timeRmaining)")
      .font(.title)
      .foregroundStyle(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(.black.opacity(0.7))
      .clipShape(.capsule)
  }
  
  var withoutColorAlternativeHelper: some View {
    VStack {
      Spacer()
      
      HStack {
        Image(systemName: "xmark.circle")
          .padding()
          .background(.black)
          .clipShape(.circle)
        
        Spacer()
        
        Image(systemName: "checkmark.circle")
          .padding()
          .background(.black)
          .clipShape(.circle)
      }
      .foregroundStyle(.white)
      .font(.largeTitle)
      .padding()
    }
  }
  
  
  // MARK: FUNCTIONS
  
  func removeCard(at index: Int) {
    cards.remove(at: index)
  }
}


extension View {
  func stacked(at position: Int, in total: Int) -> some View {
    let offset = Double(total - position)
    return self.offset(y: offset * 10)
  }
}

#Preview {
  ContentView()
}
