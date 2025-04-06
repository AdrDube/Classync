//  Classync
//
//  Created by Praise Gavi on 4/5/25.
//
import SwiftUI

extension Color {
    static let normalCountColor = Color(hex: "A9CC2E") // Lime Green
    static let runningOutColor = Color(hex: "F15C33")  // Orange/Coral
}

struct HomeView: View {

    @ObservedObject var sessionManager: SessionManager
    @State private var timeRemaining: Int = 60
    @State private var timerActive: Bool = true
    let classTitle: String
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                VStack {
                    // Header
                    HStack {
                        Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 5)

                        Spacer()

                        Image(systemName: "bell.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.primary)
                            .clipShape(Circle())
                            .padding(.trailing, 5)
                    }
                    .frame(maxWidth: geometry.size.width, maxHeight: 70)
                    .padding(.horizontal, 25)

                    Spacer().frame(height: 10)

                    // Welcome
                    HStack(spacing: 8) {
                        Text("Welcome")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

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
                    .padding(.top, 5)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 4)
                    .multilineTextAlignment(.center)

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
                            .frame(height: geometry.size.height * 0.55)

                        VStack {
                            // Timer Circle
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .opacity(0.3)
                                    .foregroundColor(Color.gray)

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
                                        .foregroundColor(.primary)
                                    Text("minutes left")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(width: min(geometry.size.width * 0.7, 250), height: min(geometry.size.width * 0.7, 250))
                            .padding()
                            .onReceive(timer) { _ in
                                if timerActive && timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }

                            // Class Title
                            VStack(spacing: 4) {
                                Text(classTitle)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)

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

                    // Buttons
                    HStack(spacing: 45) {
                        Button(action: {
                            isShowingScanner = true
                        }) {
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
                        .sheet(isPresented: $isShowingScanner) {
                            QRCodeScannerView { result in
                                self.scannedCode = result
                                self.isShowingScanner = false
                                print("Scanned QR Code: \(result)")
                            }
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

    // MARK: - Gradient Color Logic
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

