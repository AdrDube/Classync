//
//  ConnectedView.swift
//  classync
//
//  Created by Adriel Dube on 3/29/25.
//

import SwiftUI
import NearbyInteraction



struct ConnectedView: View {
    
    @ObservedObject var sessionManager: SessionManager
    @State private var azimuth: Double = 0.0
    @State private var elevation: Double = 0.0
    @State private var arrowAngle: Double = 0.0
    
    var body: some View {
        VStack {
            Text(sessionManager.status)
            Text(sessionManager.distance)
                .font(.largeTitle)
            ZStack{
                RippleEffect(
                    color: distanceColor,
                    animationDuration: animationSpeed,
                    scale: 2,
                    lineWidth: 12
                    )
                    .frame(width: 150, height: 150)
                Image(systemName: "arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: arrowAngle))
                    .animation(.easeInOut(duration: 0.5), value: arrowAngle)
                
            }
          
        }
        .onAppear {
            if let direction = sessionManager.direction {
                updateArrowAngle(direction: direction)
            }
        }
        .onChange(of: sessionManager.direction) { oldValue, newValue in
            if let newDirection = newValue {
                updateArrowAngle(direction: newDirection)
            }
        }
        .fullScreenCover(isPresented: $sessionManager.confirmedAttendance){
            ConfirmationView(sessionManager: sessionManager)
        }
    }
    
    var distanceColor: Color {
        if sessionManager.currDistance < 0.5{
                    return .green
            }
        return .blue // Default color
        }
        

    var animationSpeed: Double {
        if sessionManager.currDistance > 2.0 {
                    return 1.5
        } else if sessionManager.currDistance > 1.0 {
                    return 1.2
                } else {
                    return 1.0
                }
    }
        
    func updateArrowAngle(direction: simd_float3) {
        let calculatedAzimuth = azimuth(from: direction)
        arrowAngle = Double(calculatedAzimuth.radiansToDegrees)
    }
    
    func azimuth(from vector: simd_float3) -> Float {
        return atan2(vector.y, vector.x)
    }
    
}

extension Float {
    var radiansToDegrees: Double {
        return Double(self) * (180 / .pi)
    }
}
