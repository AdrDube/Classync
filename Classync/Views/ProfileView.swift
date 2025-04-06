// ProfileView.swift
// Classync
// Created by Praise Gavi on 4/5/25.

import SwiftUI

struct ProfileView: View {
    @Binding var loggedIn: Bool
    @State private var username = "John Doe"
    @State private var studentID = "G0012345"
    @State private var major = "Computer Science"
    @State private var semester = "Fall 2023"
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @State private var notificationsEnabled = true

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 15) {
                    // Profile header
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.orange.opacity(0.6),
                                            Color.pink.opacity(0.6)
                                        ]),
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
                            .foregroundColor(.primary)
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)

                        Text(studentID)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Student information
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Student Information")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.orange)
                            .padding(.bottom, 3)

                        InfoRow(label: "Major", value: major)
                        InfoRow(label: "Semester", value: semester)
                        InfoRow(label: "Total Classes", value: "5")
                        InfoRow(label: "GPA", value: "3.8")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)

                    // Settings
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.orange)
                            .padding(.bottom, 3)

                        // Appearance Picker
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(.orange)
                                Text("Appearance")
                                    .foregroundColor(.primary)
                            }

                            Picker("Appearance", selection: $appTheme) {
                                Text("System").tag(AppTheme.system)
                                Text("Light").tag(AppTheme.light)
                                Text("Dark").tag(AppTheme.dark)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        Toggle(isOn: $notificationsEnabled) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.orange)
                                Text("Notifications")
                                    .foregroundColor(.primary)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .orange))

                        // Log Out Button
                        Button(action: {
                            withAnimation {
                                loggedIn = false
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                    .foregroundColor(.orange)
                                Text("Log Out")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
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
                    .foregroundColor(.primary)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .font(.system(size: 15))
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ProfileView(loggedIn: .constant(true))
}
