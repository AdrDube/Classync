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
            
            ScrollView {
                VStack(spacing: 15) {
                    // Summary bar chart
                    VStack(alignment: .leading) {
                        Text("Attendance Summary")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        AttendanceBarChart(classes: classes)
                            .frame(height: 120)
                            .background(Color(hex: "#222222"))
                            .cornerRadius(12)
                            .shadow(color: .orange.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                    
                    // Class list
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
                    .foregroundColor(.white)
            }
        }
    }
}

struct ClassCardView: View {
    @Binding var classItem: ClassAttendance
    @Namespace private var animation

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Class header button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    classItem.isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(classItem.courseName)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Instructor: \(classItem.instructor)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: classItem.isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.orange)
                        .rotationEffect(classItem.isExpanded ? .degrees(0) : .degrees(0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: classItem.isExpanded)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Color(hex: "#222222"))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable content
            if classItem.isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Total Classes:")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(classItem.totalClasses)")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Attended:")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(classItem.attended)")
                            .foregroundColor(.attendedColor)
                    }
                    
                    HStack {
                        Text("Missed:")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(classItem.missed)")
                            .foregroundColor(.absentColor)
                    }
                    
                    HStack {
                        Text("Tardies:")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(classItem.tardies)")
                            .foregroundColor(.lateColor)
                    }
                    
                    // Attendance bar for this class
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
                            .frame(height: 10)
                        }
                        .frame(height: 10)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(hex: "#1A1A1A"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                .padding(.top, 2)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity).animation(.spring(response: 0.3, dampingFraction: 0.8)),
                    removal: .scale(scale: 0.95).combined(with: .opacity).animation(.spring(response: 0.25, dampingFraction: 0.8))
                ))
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
            AttendanceSegment(status: "On Time", count: totalAttended, color: .attendedColor),
            AttendanceSegment(status: "Late", count: totalTardies, color: .lateColor),
            AttendanceSegment(status: "Absent", count: totalMissed, color: .absentColor)
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
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .frame(height: 20)
            
            // Legend text
            Text("Total Classes: \(totalClasses)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    HistoryView()
}
