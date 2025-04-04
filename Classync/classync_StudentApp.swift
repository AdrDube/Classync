//
//  classync_StudentApp.swift
//  classync-Student
//
//  Created by Adriel Dube on 3/30/25.
//
import SwiftUI
import UserNotifications

import SwiftUI
import UserNotifications

@main
struct classyncApp: App {
    @StateObject private var sessionManager = SessionManager(sharedDiscovery: SharedPeerDiscovery())
    @State private var loggedIn: Bool = false
    
    init() {
        Notifications.initialize()
        Notifications.sendNotification(text: "You have 20 minutes until Dr. Haj's 9 a.m. Calc I class", delay: 8)
    }
    
    var body: some Scene {
            WindowGroup {
                ZStack {
                    if loggedIn {
                        MainTabView(sessionManager: sessionManager)
                    } else {
                        SignInScreenView(loggedIn: $loggedIn)
                            .preferredColorScheme(.dark)
                    }
                }
            }
        }

}


struct classyncApp_Previews: PreviewProvider {
    static var previews: some View {
        struct PreviewContent: View {
            @State private var loggedIn = false
            let sessionManager = SessionManager(sharedDiscovery: SharedPeerDiscovery())
            
            var body: some View {
                SignInScreenView(loggedIn: $loggedIn)
                    .preferredColorScheme(.dark)
                    .sheet(isPresented: $loggedIn) {
                        MainTabView(sessionManager: sessionManager)
                    }
            }
        }
        return PreviewContent()
    }
}
