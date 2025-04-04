//
//  ProfileView.swift
//  view_scope
//
//  Created by Shalom Donga on 3/29/25.
//

//
//  Profile.swift
//  classync
//
//  Created by Shalom Donga on 3/29/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var username = "John Doe"
    @State private var studentID = "G0012345"
    @State private var major = "Computer Science"
    @State private var semester = "Fall 2023"
    @State private var darkModeEnabled = true
    @State private var notificationsEnabled = true
    
    var body: some View {
        // NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 15) {
                        // Profile header
                        VStack(spacing: 10) {
                            
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "FF9933").opacity(0.7), Color(hex: "FF5E62").opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 110, height: 110)
                                    .shadow(color: Color.orange.opacity(0.4), radius: 10, x: 0, y: 5)
                                
                                Image("Image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 140, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            Text(username)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                            
                            Text(studentID)
                                .font(.system(size: 16, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        Spacer()
                        
                        // Student information
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Student Information")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                                .padding(.bottom, 3)
                            
                            InfoRow(label: "Major", value: major)
                            InfoRow(label: "Semester", value: semester)
                            InfoRow(label: "Total Classes", value: "5")
                            HStack {
                                    Text("GPA")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("3.8")
                                        .foregroundColor(.orange)
                                        .fontWeight(.bold)
                                }
                        }
                        .padding()
                        .background(Color(hex: "222222"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                        
                        // Settings
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Settings")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                                .padding(.bottom, 3)
                            
                            Toggle(isOn: $darkModeEnabled) {
                                HStack {
                                    Image(systemName: "moon.fill")
                                        .foregroundColor(.orange)
                                    Text("Dark Mode")
                                        .foregroundColor(.white)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            
                            Toggle(isOn: $notificationsEnabled) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.orange)
                                    Text("Notifications")
                                        .foregroundColor(.white)
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                        .foregroundColor(.orange)
                                    Text("Log Out")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color(hex: "222222"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)

                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        // .navigationViewStyle(StackNavigationViewStyle())
    // }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(Color.gray.opacity(0.7))
                .font(.system(size: 15))
            Spacer()
            Text(value)
                .foregroundColor(Color.white.opacity(0.9))
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ProfileView()
}
