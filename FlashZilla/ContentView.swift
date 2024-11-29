//
//  ContentView.swift
//  FlashZilla
//
//  Created by Илья Гринько on 29.11.2024.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
  @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
  @Environment(\.scenePhase) var scenePhase
  
  //  @State private var cards = Array<Card>(repeating: .example, count: 10) -> simple example
  @State private var cards = [Card]()
  @State private var timeRmaining = 100
  @State private var isActive = true
  @State private var showingEditScreen = false
  
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
            .allowsHitTesting(index == cards.count - 1)
            .accessibilityHidden(index < cards.count - 1)
          }
        }
        .allowsHitTesting(timeRmaining > 0)
        
        if cards.isEmpty {
          startAgaingButton
        }
      }
      
      editButton
      
      
      if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
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
        if cards.isEmpty == false {
          isActive = true
        }
      } else {
        isActive = false
      }
    }
    .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
    .onAppear(perform: resetCards)
  }
  
  // MARK: VIEWS
  
  var editButton: some View {
    VStack {
      HStack {
        Spacer()
        Button {
          showingEditScreen = true
        } label: {
          Image(systemName: "plus.circle")
            .padding()
            .background(.black.opacity(0.7))
            .clipShape(.circle)
        }
      }
      Spacer()
    }
    .foregroundStyle(.white)
    .font(.title3)
    .padding()
    
  }
  
  var startAgaingButton: some View {
    Button("Start again", action: resetCards)
      .padding()
      .foregroundStyle(.black)
      .background(.white)
      .clipShape(.capsule)
      .padding()
  }
  
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
        Button {
          withAnimation {
            removeCard(at: cards.count - 1)
          }
        } label: {
          Image(systemName: "xmark.circle")
            .padding()
            .background(.black)
            .clipShape(.circle)
        }
        .accessibilityLabel("Wrong")
        .accessibilityHint("Mark your answer as being incorrect")
        
        Spacer()
        
        Button {
          withAnimation {
            removeCard(at: cards.count - 1)
          }
        } label: {
          Image(systemName: "checkmark.circle")
            .padding()
            .background(.black)
            .clipShape(.circle)
        }
        .accessibilityLabel("Correct")
        .accessibilityHint("Mark your answer as being correct")
      }
      .foregroundStyle(.white)
      .font(.largeTitle)
      .padding()
    }
  }
  
  
  // MARK: FUNCTIONS
  
  func removeCard(at index: Int) {
    guard index >= 0 else { return }
    
    cards.remove(at: index)
    
    if cards.isEmpty {
      isActive = false
    }
  }
  
  func resetCards() {
    timeRmaining = 100
    isActive = true
    loadData()
  }
  
  func loadData() {
    if let data = UserDefaults.standard.data(forKey: "Cards") {
      if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
        cards = decoded
      }
    }
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
