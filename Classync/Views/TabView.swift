//
//  TabView.swift
//  view_scope
//
//  Created by Shalom Donga on 3/29/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        TabView {
            // Wrap each main view in its own NavigationStack
            NavigationStack {
                HomeView(sessionManager: sessionManager, classTitle: "Calculus 101")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            
            NavigationStack {
                NotificationsView()
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Notifications")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.orange) // Highlight color for selected tab
        .background(.black)
    }
}

