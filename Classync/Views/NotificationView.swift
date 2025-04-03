//
//  NotificationView.swift
//  view_scope
//
//  Created by Shalom Donga on 3/29/25.
//

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let message: String
    let isRead: Bool
    let time: String
    let icon: String?
    let relatedClass: String?
}

struct NotificationsView: View {
    @State private var isReminderOn = true
    @State private var notifications: [Notification] = [
        Notification(message: "CS 201 class was moved to Room 205", isRead: false, time: "20m ago", icon: "arrow.right", relatedClass: "CS 201"),
        Notification(message: "No HIST 101 class meeting today", isRead: false, time: "1h ago", icon: "calendar.badge.minus", relatedClass: "HIST 101"),
        Notification(message: "Join MATH 273 meeting via Zoom", isRead: false, time: "2h ago", icon: "video.fill", relatedClass: "MATH 273"),
        Notification(message: "CS 201 starting in 10 minutes", isRead: true, time: "5h ago", icon: "clock.fill", relatedClass: "CS 201"),
        Notification(message: "HIST 101 starting in 5 minutes", isRead: true, time: "1d ago", icon: "clock.fill", relatedClass: "HIST 101"),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 15) {
                    // Toggle for reminders
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                        
                        Toggle("Allow class reminders", isOn: $isReminderOn)
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    // Notification list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(notifications.indices, id: \.self) { index in
                                NotificationRow(notification: notifications[index])
                                    .onTapGesture {
                                        if !notifications[index].isRead {
                                            markAsRead(index: index)
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    // Mark all as read button
                    if notifications.contains(where: { !$0.isRead }) {
                        Button(action: markAllAsRead) {
                            HStack {
                                Spacer()
                                Text("Mark all as read")
                                    .foregroundColor(.orange)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .padding(.top, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Notifications")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func markAsRead(index: Int) {
        withAnimation {
            notifications[index] = Notification(
                message: notifications[index].message,
                isRead: true,
                time: notifications[index].time,
                icon: notifications[index].icon,
                relatedClass: notifications[index].relatedClass
            )
        }
    }
    
    private func markAllAsRead() {
        withAnimation {
            notifications = notifications.map { notification in
                Notification(
                    message: notification.message,
                    isRead: true,
                    time: notification.time,
                    icon: notification.icon,
                    relatedClass: notification.relatedClass
                )
            }
        }
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            if let icon = notification.icon {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(notification.isRead ? 0.3 : 0.7))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .foregroundColor(notification.isRead ? .gray : .white)
                        .font(.system(size: 16))
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                if let relatedClass = notification.relatedClass {
                    Text(relatedClass)
                        .font(.caption)
                        .foregroundColor(notification.isRead ? .gray : .orange)
                        .fontWeight(.semibold)
                }
                
                Text(notification.message)
                    .foregroundColor(notification.isRead ? .gray : .white)
                    .lineLimit(2)
                
                Text(notification.time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Unread indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal, 2)
        .ignoresSafeArea(edges:.bottom)
    }
}

#Preview {
    NotificationsView()
}
