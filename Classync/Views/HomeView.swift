import SwiftUI

extension Color {
    static let normalCountColor = Color(hex: "A9CC2E") // Lime Green
    static let runningOutColor = Color(hex: "F15C33") // Orange/Coral
}
    
struct HomeView: View {
    
    @ObservedObject var sessionManager : SessionManager
 
    @State private var timeRemaining: Int = 60 // Initial time in minutes (one hour)
    @State private var timerActive: Bool = true
    let classTitle: String
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every minute
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    // Header area - adjusted padding
                    HStack {
                        Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 50)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "bell.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .padding(.trailing, 5)
                    }
                    .frame(maxWidth: geometry.size.width, maxHeight: 70)
                    .padding(.horizontal, 25) // Increased padding
                    
                    Spacer().frame(height: 10)
                    
                    // Welcome text - removed comma and added gradient
                    HStack(spacing: 8) {
                        Text("Welcome")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("John")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.orange, Color(hex: "FF8C42")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .orange.opacity(0.6), radius: 4, x: 0, y: 0)
                    }
                    .padding(.top, 5) // Moved closer to profile picture
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 4)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black)
                            .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 10)
                            .frame(height: geometry.size.height * 0.55)
                        
                        VStack {
                            // Timer with gradient ring
                            ZStack {
                                // Background circle
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .opacity(0.3)
                                    .foregroundColor(Color.gray)
                                
                                // Progress circle with gradient
                                Circle()
                                    .trim(from: 1.0 - min(CGFloat(timeRemaining) / 60, 1.0), to: 1.0)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [progressGradientStart, progressGradientEnd]),
                                            center: .center,
                                            startAngle: .degrees(0),
                                            endAngle: .degrees(360)
                                        ),
                                        style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)
                                    )
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .animation(.linear, value: timeRemaining)
                                    .shadow(color: progressGradientEnd.opacity(0.6), radius: 5, x: 0, y: 0)
                                
                                VStack {
                                    Text("\(timeRemaining)")
                                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                                        .foregroundColor(.white)
                                    Text("minutes left")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: min(geometry.size.width * 0.7, 250), height: min(geometry.size.width * 0.7, 250))
                            .padding()
                            .onReceive(timer) { _ in
                                if timerActive && timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                            
                            // Enhanced class title with icon and underline
                            VStack(spacing: 4) {
                                HStack {
//                                    Image(systemName: "book.fill")
//                                        .foregroundColor(.orange)
//                                        .font(.system(size: 22))
                                    
                                    Text(classTitle)
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                
                                Rectangle()
                                    .frame(width: min(geometry.size.width * 0.6, 220), height: 2)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.orange.opacity(0.3), Color.orange, Color.orange.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                            .padding(.top, 5)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 4)
                        }
                    }
                    
                    Spacer()
                    
                    // Buttons with refined styling
                    HStack(spacing: 45) {
                        Button(action: {}) {
                            VStack {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.system(size: 24))
                                    .padding(.bottom, 5)
                                Text("Scan QR Code")
                                    .font(.system(.headline, design: .rounded))
                                    .tracking(0.3)
                            }
                            .frame(width: geometry.size.width * 0.35, height: 80)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "FAA977"), Color(hex: "D97904")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "FF5E62").opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        
                        Button(action: {
                            sessionManager.startup()
                        }) {
                            VStack {
                                Image(systemName: "iphone.radiowaves.left.and.right")
                                    .font(.system(size: 24))
                                    .padding(.bottom, 5)
                                Text("Detect Device")
                                    .font(.system(.headline, design: .rounded))
                                    .tracking(0.3)
                            }
                            .frame(width: geometry.size.width * 0.35, height: 80)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "FAA977"), Color(hex: "D97904")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "FF5E62").opacity(0.3), radius: 6, x: 0, y: 3)
                            .sheet(isPresented: $sessionManager.findPeer) {
                                NIView(sessionManager: sessionManager)
                            }

                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    // Updated progress colors with gradients
    var progressGradientStart: Color {
        if timeRemaining <= 5 {
            return Color(hex: "FF5E62")
        } else if timeRemaining <= 15 {
            return Color(hex: "FF9966")
        } else {
            return Color(hex: "B5CC2E")
        }
    }
    
    var progressGradientEnd: Color {
        if timeRemaining <= 5 {
            return Color.red
        } else if timeRemaining <= 15 {
            return .runningOutColor
        } else {
            return .normalCountColor
        }
    }
    
    // Original color for backward compatibility
    var progressColor: Color {
        if timeRemaining <= 5 {
            return .red
        } else if timeRemaining <= 15 {
            return .runningOutColor
        } else {
            return .normalCountColor
        }
    }
}

