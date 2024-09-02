//
//  OnBoardingView.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/30/24.
//

import SwiftUI
import Foundation

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your cooking book".map { String($0) }
    @State private var showLoadingText: Bool = false
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    private let colors: [Color] = [.theme.accent, .pink, .theme.accent, .theme.secondary, .theme.accent, .theme.accent, .theme.accent, .theme.secondary, .theme.accent]
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var stepper: Float = 0
    
    @Binding var showLaunchView: Bool
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            GeometryReader { i in
                    colors[Int.random(in: 0..<4)].opacity(0.4)
                    .frame(height: i.size.height * CGFloat(stepper))
                        .blur(radius: 40)
                        .ignoresSafeArea()
                
                
            }
            
            HStack {
                ZStack {
                    if showLoadingText {
                        HStack(spacing: 0) {
                            ForEach(loadingText.indices) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(colors[Int.random(in: 0..<6)])
                                    .offset(y: counter == index ? -1 : 0)
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                    
                }
                .offset(y: 2)
            }
            .transition(AnyTransition.scale.animation(.easeIn))

            
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                
                let lastIndex = loadingText.count - 5
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 1 {
                        showLaunchView = false
                        self.timer.upstream.connect().cancel()
                    }
                } else {
                    counter += 1
                    stepper = min(stepper + 0.09, 1.0)
                }
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
            .preferredColorScheme(.light)
    }
}
