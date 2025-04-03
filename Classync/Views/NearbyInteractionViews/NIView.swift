//
//  NIView.swift
//  classync
//
//  Created by Adriel Dube on 3/29/25.
//

import SwiftUI

struct RippleEffect: View {
    var color: Color = .blue
    var numRipples: Int = 3
    var animationDuration: Double = 2.0
    var scale: Double = 1
    var lineWidth = 12
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<numRipples, id: \.self) { index in
                RippleCircle(
                    index: index,
                    numRipples: numRipples,
                    lineWidth: lineWidth,
                    color: color,
                    duration: animationDuration,
                    scale: scale,
                    isAnimating: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}


struct RippleCircle: View {
    let index, numRipples, lineWidth: Int
    let color: Color
    let duration, scale: Double
    let isAnimating: Bool
    
    var body: some View {
        Circle()
            .stroke(color.opacity(0.8), lineWidth: CGFloat(lineWidth))
            .scaleEffect(isAnimating ? scale + CGFloat(index) / CGFloat(numRipples) : 0.1)
            .opacity(isAnimating ? 0 : 0.8) // Start visible, fade to invisible
            .animation(rippleAnimation, value: isAnimating)
    }
    
    private var rippleAnimation: Animation {
        let delay = Double(index) * (duration / Double(numRipples))
        return Animation.easeOut(duration: duration)
            .repeatForever(autoreverses: false)
            .delay(delay)
    }
}


struct NIView: View {
    @ObservedObject var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    let peerSize: CGFloat = 120
    let spacing: CGFloat = 60
 
    var body: some View {
        VStack {
            Text("Discovered Devices")
                .foregroundColor(.gray)
                .font(.largeTitle)
                .padding(.top)

            GeometryReader { geometry in
                ZStack {
                    Color.black.ignoresSafeArea()
                    ForEach(Array(sessionManager.discoveredDevices.enumerated()), id: \.offset) { index, peer in
                        ZStack{
                            RippleEffect(
                                color: .blue,
                                animationDuration: 4,
                                scale: 1
                            )
                            Button(action: {
                                sessionManager.connect(peerID: peer)
                                print("Connected")
                            }) {
                                Text(peer.displayName)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                            .background(Color.gray)
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .position(calculatePosition(index: index, geometry: geometry, numOfPeers: sessionManager.discoveredDevices.count))
                        }
                    }
                    
                    // Add a back button to properly dismiss this view
                    VStack {
                        HStack {
                            Button(action: {
                                sessionManager.findPeer = false
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.gray.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .sheet(isPresented: $sessionManager.connected) {
                    ConnectedView(sessionManager: sessionManager)
                }
            }
        }
        .onDisappear {
            // Make sure state is updated when view disappears
            sessionManager.findPeer = false
        }
    }
    
    // MARK: - Additional func
    func calculatePosition(index: Int, geometry: GeometryProxy, numOfPeers: Int) -> CGPoint {
        // Your existing calculation code
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2

        switch numOfPeers {
        case 1:
            return CGPoint(x: centerX, y: centerY)
        case 2:
            return CGPoint(x: centerX + CGFloat(index * 2 - 1) * (peerSize + spacing) / 2, y: centerY)
        case 3:
            if index == 0 {
                return CGPoint(x: centerX, y: centerY - (peerSize + spacing) / 2)
            } else {
                return CGPoint(x: centerX + CGFloat(index - 2) * (peerSize + spacing), y: centerY + (peerSize + spacing) / 2)
            }
        case 4:
            if index < 2 {
                return CGPoint(x: centerX + CGFloat(index * 2 - 1) * (peerSize + spacing) / 2, y: centerY - (peerSize + spacing) / 2)
            } else {
                return CGPoint(x: centerX + CGFloat((index - 2) * 2 - 1) * (peerSize + spacing) / 2, y: centerY + (peerSize + spacing) / 2)
            }
        default:
            // More complex distribution for 5+ items
            let angle = CGFloat(index) * (2 * .pi / CGFloat(numOfPeers))
            let radius = min(geometry.size.width, geometry.size.height) / 3
            return CGPoint(x: centerX + radius * cos(angle), y: centerY + radius * sin(angle))
        }
    }
}
