// classync_StudentApp.swift
// classync-Student

import SwiftUI
import UserNotifications

@main
struct classyncApp: App {
    @StateObject private var sessionManager = SessionManager(sharedDiscovery: SharedPeerDiscovery())
    @State private var loggedIn: Bool = false
    
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

    init() {
        Notifications.initialize()
        Notifications.sendNotification(
            text: "You have 20 minutes until Dr. Haj's 9 a.m. Calc I class",
            delay: 8
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if loggedIn {
                    MainTabView(sessionManager: sessionManager, loggedIn: $loggedIn)
                } else {
                    SignInScreenView(loggedIn: $loggedIn)
                }
            }
            .preferredColorScheme(
                appTheme == .system ? nil :
                appTheme == .light ? .light : .dark
            )
        }
    }
}

struct classyncApp_Previews: PreviewProvider {
    static var previews: some View {
        struct PreviewContent: View {
            @State private var loggedIn = false
            let sessionManager = SessionManager(sharedDiscovery: SharedPeerDiscovery())
            @AppStorage("appTheme") private var appTheme: AppTheme = .system

            var body: some View {
                SignInScreenView(loggedIn: $loggedIn)
                    .preferredColorScheme(
                        appTheme == .system ? nil :
                        appTheme == .light ? .light : .dark
                    )
                    .sheet(isPresented: $loggedIn) {
                        MainTabView(sessionManager: sessionManager, loggedIn: $loggedIn)
                            .preferredColorScheme(
                                appTheme == .system ? nil :
                                appTheme == .light ? .light : .dark
                            )
                    }
            }
        }
        return PreviewContent()
    }
}
