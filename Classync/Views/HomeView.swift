import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionManager : SessionManager
    @State private var timeRemaining: Int = 60 // Initial time in minutes (one hour)
    @State private var timerActive: Bool = true
    let classTitle: String
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every minute
    
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    // Header with logo and notification
                    HStack {
                        Image("Image")  // Using image from assets folder
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 50)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Image(systemName: "bell.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: geometry.size.width, maxHeight: 70)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Main content area
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black)
                        .frame(height: geometry.size.height * 0.85)
                        .overlay(
                            VStack(spacing: 30) {
            
                                Text("Welcome, John")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                
                                Spacer()
                                
                                // Countdown timer with progress circle
                                ZStack {
                                    // Background circle
                                    Circle()
                                        .stroke(lineWidth: 15)
                                        .opacity(0.3)
                                        .foregroundColor(Color.gray)
                                    // Progress circle
                                    Circle()
                                        .trim(from: 1.0 - min(CGFloat(timeRemaining) / 60, 1.0), to: 1.0)
                                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(progressColor)
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.linear, value: timeRemaining)
                                    
                                    // Time remaining display
                                    VStack {
                                        Text("\(timeRemaining)")
                                            .font(.system(size: 50, weight: .bold, design: .rounded))
                                            .foregroundColor(progressColor)
                                        
                                        Text("minutes left")
                                            .font(.headline)
                                            .foregroundColor(progressColor)
                                    }
                                }
                                .frame(width: min(geometry.size.width * 0.7, 250), height: min(geometry.size.width * 0.7, 250))
                                .padding()
                                .onReceive(timer) { _ in
                                    if timerActive && timeRemaining > 0 {
                                        timeRemaining -= 1
                                    }
                                }
                                
                                Spacer()
                                
                                Text(classTitle)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)
                                
                                Spacer()
                                
                                // Action buttons
                                HStack(spacing: 20) {
                                    // QR Code Scan Button
                                    Button(action: {
                                        // Action for QR Code scanning
                                    }) {
                                        VStack {
                                            Image(systemName: "qrcode.viewfinder")
                                                .font(.system(size: 24))
                                                .padding(.bottom, 5)
                                            Text("Scan QR Code")
                                                .font(.headline)
                                        }
                                        .frame(width: geometry.size.width * 0.4, height: 80)
                                        .foregroundColor(.white)
                                        .background(Color.orange)
                                        .cornerRadius(15)
                                    }
                                    
                                    // Detect Device Button
                                    Button(action: {
                                        sessionManager.startup()
                                    }) {
                                        VStack {
                                            Image(systemName: "iphone.radiowaves.left.and.right")
                                                .font(.system(size: 24))
                                                .padding(.bottom, 5)
                                            Text("Detect Device")
                                                .font(.headline)
                                        }
                                        .frame(width: geometry.size.width * 0.4, height: 80)
                                        .foregroundColor(.white)
                                        .background(Color.orange)
                                        .cornerRadius(15)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 40)
                                
                            }
                        )
                        .edgesIgnoringSafeArea(.bottom)
                        .sheet(isPresented: $sessionManager.findPeer) {
                            NIView(sessionManager: sessionManager)
                        }
                }
            }
        }
    }
    
    // Color changes based on time remaining
    var progressColor: Color {
        if timeRemaining <= 5 {
            return .red
        } else if timeRemaining <= 15 {
            return .orange
        } else {
            return .green
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sessionManager: SessionManager(sharedDiscovery: SharedPeerDiscovery()), classTitle: "Calculus 101")
    }
}

