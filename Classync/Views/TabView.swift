import SwiftUI

struct MainTabView: View {
    @ObservedObject var sessionManager: SessionManager
    @Binding var loggedIn: Bool

    var body: some View {
        TabView {
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
                ProfileView(loggedIn: $loggedIn) // ✅ passing loggedIn binding
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.orange)
    }
}
