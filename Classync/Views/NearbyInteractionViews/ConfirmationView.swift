//
//  ConfirmationView.swift
//  classync
//
//  Created by Adriel Dube on 3/30/25.
//

import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var sessionManager: SessionManager
    @State private var border = false
    @State private var spinArrow = false
    @State private var dismissArrow = false
    @State private var displayCheckmark = false
    @Environment(\.presentationMode) var presentationMode
    @State private var autoReturnTriggered = false
    
    var body: some View {
        ZStack{
            Color.orange.ignoresSafeArea()
            VStack {
                Text("Successfully registered attendance for 9:00AM Calculus with Dr Haj")
                    .font(.title)
                    .fontWeight(.bold)
                    .opacity(displayCheckmark ? 1 : 0)
                    .animation(.easeIn.delay(3.5), value: displayCheckmark)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Main Animation Container
                ZStack {
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: border ? 10 : 64))
                        .frame(width: 250, height: 250)
                        .foregroundStyle(.white)
                        .onAppear {
                            withAnimation(.easeOut(duration: 3).speed(1.5)) {
                                border.toggle()
                            }
                        }
                    
                    // Arrow Icon - Now properly centered
                    Image(systemName: "arrow.2.circlepath")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(spinArrow ? 360 : -360))
                        .opacity(dismissArrow ? 0 : 1)
                        .onAppear {
                            withAnimation(.easeOut(duration: 4)) {
                                spinArrow.toggle()
                                
                                withAnimation(.easeInOut(duration: 3).delay(1)) {
                                    dismissArrow.toggle()
                                }
                            }
                        }
                    
                    // Checkmark - Modified to be centered
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))
                        path.addLine(to: CGPoint(x: 30, y: 60))
                        path.addLine(to: CGPoint(x: 90, y: 0))
                    }
                    .trim(from: 0, to: displayCheckmark ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(displayCheckmark ? .white : .black)
                    .frame(width: 90, height: 60)
                    .onAppear {
                        withAnimation(.spring(bounce: 0.5, blendDuration: 3).delay(3)) {
                            displayCheckmark.toggle()
                        }
                        
                        // Schedule auto-return after animation sequence completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                            sessionManager.endSession()
                        }
                    }
                }
                .frame(width: 150, height: 150)  // Ensure the ZStack itself has a fixed size
                .padding(.vertical, 40)
            }
            .onChange(of: autoReturnTriggered) { oldValue, newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
        }
    }
}
 
