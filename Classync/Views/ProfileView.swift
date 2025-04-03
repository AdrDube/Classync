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
    @State private var username = "Michael Porter"
    @State private var studentID = "G0012345"
    @State private var major = "Computer Science"
    @State private var semester = "Spring 2025"
    @State private var darkModeEnabled = true
    @State private var notificationsEnabled = true
    
    var body: some View {
        // NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile header
                        VStack(spacing: 15) {
                            Image("Image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 100)
                                .foregroundColor(.orange)
                                .clipShape(Circle())
                            
                            Text(username)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(studentID)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // Student information
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Student Information")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            InfoRow(label: "Major", value: major)
                            InfoRow(label: "Semester", value: semester)
                            InfoRow(label: "Total Classes", value: "5")
                            InfoRow(label: "GPA", value: "3.8")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        
                        // Settings
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.white)
                            
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
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
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
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ProfileView()
}
