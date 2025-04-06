//  Classync
//
//  Created by Praise Gavi on 4/5/25.
//
import SwiftUI
import Charts

struct ClassAttendance: Identifiable {
    let id = UUID()
    let courseName: String
    let instructor: String
    let totalClasses: Int
    let attended: Int
    let missed: Int
    let tardies: Int
    var isExpanded: Bool = false
}

struct HistoryView: View {
    @State private var classes: [ClassAttendance] = [
        ClassAttendance(courseName: "CS 201", instructor: "Dr. Smith", totalClasses: 20, attended: 16, missed: 3, tardies: 1),
        ClassAttendance(courseName: "HIST 101", instructor: "Prof. Johnson", totalClasses: 18, attended: 14, missed: 3, tardies: 1),
        ClassAttendance(courseName: "MATH 273", instructor: "Dr. Brown", totalClasses: 15, attended: 12, missed: 2, tardies: 1)
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("Attendance Summary")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        AttendanceBarChart(classes: classes)
                            .frame(height: 120)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .shadow(color: .orange.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(classes.indices, id: \.self) { index in
                            ClassCardView(classItem: $classes[index])
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
        }
        .navigationTitle("Attendance History")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Attendance History")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ClassCardView: View {
    @Binding var classItem: ClassAttendance
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    classItem.isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(classItem.courseName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Instructor: \(classItem.instructor)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: classItem.isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.orange)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            
            if classItem.isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Total Classes:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(classItem.totalClasses)")
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Text("Attended:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(classItem.attended)")
                            .foregroundColor(.attendedColor)
                    }
                    HStack {
                        Text("Missed:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(classItem.missed)")
                            .foregroundColor(.absentColor)
                    }
                    HStack {
                        Text("Tardies:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(classItem.tardies)")
                            .foregroundColor(.lateColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Attendance Rate")
                            .foregroundColor(.orange)
                            .font(.caption)
                        
                        GeometryReader { geometry in
                            HStack(spacing: 2) {
                                let attendedWidth = CGFloat(classItem.attended) / CGFloat(classItem.totalClasses) * geometry.size.width
                                let tardiesWidth = CGFloat(classItem.tardies) / CGFloat(classItem.totalClasses) * geometry.size.width
                                let missedWidth = CGFloat(classItem.missed) / CGFloat(classItem.totalClasses) * geometry.size.width
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.attendedColor)
                                    .frame(width: attendedWidth)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.lateColor)
                                    .frame(width: tardiesWidth)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.absentColor)
                                    .frame(width: missedWidth)
                            }
                        }
                        .frame(height: 10)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                .padding(.top, 2)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                    removal: .scale(scale: 0.95).combined(with: .opacity)
                ))
            }
        }
    }
}

struct AttendanceBarChart: View {
    let classes: [ClassAttendance]
    
    struct AttendanceSegment: Identifiable {
        let id = UUID()
        let status: String
        let count: Int
        let color: Color
    }
    
    var body: some View {
        let totalClasses = classes.reduce(0) { $0 + $1.totalClasses }
        let totalAttended = classes.reduce(0) { $0 + $1.attended }
        let totalMissed = classes.reduce(0) { $0 + $1.missed }
        let totalTardies = classes.reduce(0) { $0 + $1.tardies }
        
        let segments = [
            AttendanceSegment(status: "On Time", count: totalAttended, color: .attendedColor),
            AttendanceSegment(status: "Late", count: totalTardies, color: .lateColor),
            AttendanceSegment(status: "Absent", count: totalMissed, color: .absentColor)
        ]
        
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                ForEach(segments) { segment in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(segment.color)
                            .frame(width: 10, height: 10)
                        
                        Text("\(segment.status): \(Int((Double(segment.count) / Double(totalClasses)) * 100))%")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    
                    if segment.id != segments.last?.id {
                        Spacer()
                    }
                }
            }
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    let attendedWidth = CGFloat(totalAttended) / CGFloat(totalClasses) * geometry.size.width
                    let tardiesWidth = CGFloat(totalTardies) / CGFloat(totalClasses) * geometry.size.width
                    let missedWidth = CGFloat(totalMissed) / CGFloat(totalClasses) * geometry.size.width
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.attendedColor)
                        .frame(width: attendedWidth)
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.lateColor)
                        .frame(width: tardiesWidth)
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.absentColor)
                        .frame(width: missedWidth)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 20)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .frame(height: 20)
            
            Text("Total Classes: \(totalClasses)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    HistoryView()
}
