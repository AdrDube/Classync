//
//  HistoryView.swift
//  view_scope
//
//  Created by Shalom Donga on 3/29/25.
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
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 15) {
                    
                    // Summary bar chart
                    VStack(alignment: .leading) {
                        Text("Attendance Summary")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        AttendanceBarChart(classes: classes)
                            .frame(height: 120)
                    }
                    .padding(.horizontal)
                    
                    // Class list
                    List {
                        ForEach(classes.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        classes[index].isExpanded.toggle()
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(classes[index].courseName)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text("Instructor: \(classes[index].instructor)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: classes[index].isExpanded ? "chevron.down" : "chevron.right")
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.vertical, 10)
                                }
                                
                                if classes[index].isExpanded {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Total Classes:")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("\(classes[index].totalClasses)")
                                                .foregroundColor(.white)
                                        }
                                        
                                        HStack {
                                            Text("Attended:")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("\(classes[index].attended)")
                                                .foregroundColor(.green)
                                        }
                                        
                                        HStack {
                                            Text("Missed:")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("\(classes[index].missed)")
                                                .foregroundColor(.red)
                                        }
                                        
                                        HStack {
                                            Text("Tardies:")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text("\(classes[index].tardies)")
                                                .foregroundColor(.yellow)
                                        }
                                        
                                        // Attendance bar for this class
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Attendance Rate")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                            
                                            GeometryReader { geometry in
                                                HStack(spacing: 2) {
                                                    let attendedWidth = CGFloat(classes[index].attended) / CGFloat(classes[index].totalClasses) * geometry.size.width
                                                    let tardiesWidth = CGFloat(classes[index].tardies) / CGFloat(classes[index].totalClasses) * geometry.size.width
                                                    let missedWidth = CGFloat(classes[index].missed) / CGFloat(classes[index].totalClasses) * geometry.size.width
                                                    
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.green)
                                                        .frame(width: attendedWidth)
                                                    
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.yellow)
                                                        .frame(width: tardiesWidth)
                                                    
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.red)
                                                        .frame(width: missedWidth)
                                                }
                                                .frame(height: 10)
                                            }
                                            .frame(height: 10)
                                        }
                                        .padding(.top, 4)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(8)
                                    .padding(.vertical, 5)
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding(.top)
            }
            .navigationTitle("Attendance History")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Attendance History")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    
}

// MARK: - Attendance Bar Chart
struct AttendanceBarChart: View {
    let classes: [ClassAttendance]
    
    struct AttendanceSegment: Identifiable {
        let id = UUID()
        let status: String
        let count: Int
        let color: Color
    }
    
    var body: some View {
        // Calculate totals
        let totalClasses = classes.reduce(0) { $0 + $1.totalClasses }
        let totalAttended = classes.reduce(0) { $0 + $1.attended }
        let totalMissed = classes.reduce(0) { $0 + $1.missed }
        let totalTardies = classes.reduce(0) { $0 + $1.tardies }
        
        // Create data for the segments
        let segments = [
            AttendanceSegment(status: "On Time", count: totalAttended, color: .green),
            AttendanceSegment(status: "Late", count: totalTardies, color: .yellow),
            AttendanceSegment(status: "Absent", count: totalMissed, color: .red)
        ]
        
        VStack(alignment: .leading, spacing: 15) {
            // Percentages text
            HStack {
                ForEach(segments) { segment in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(segment.color)
                            .frame(width: 10, height: 10)
                        
                        Text("\(segment.status): \(Int((Double(segment.count) / Double(totalClasses)) * 100))%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    if segment.id != segments.last?.id {
                        Spacer()
                    }
                }
            }
            
            // Custom segmented bar
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // On Time segment
                    let attendedWidth = CGFloat(totalAttended) / CGFloat(totalClasses) * geometry.size.width
                    let tardiesWidth = CGFloat(totalTardies) / CGFloat(totalClasses) * geometry.size.width
                    let missedWidth = CGFloat(totalMissed) / CGFloat(totalClasses) * geometry.size.width
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.green)
                        .frame(width: attendedWidth)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.yellow)
                        .frame(width: tardiesWidth)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.red)
                        .frame(width: missedWidth)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 20)
            }
            .frame(height: 20)
            
            // Legend text
            Text("Total Classes: \(totalClasses)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}


#Preview {
    HistoryView()
}
