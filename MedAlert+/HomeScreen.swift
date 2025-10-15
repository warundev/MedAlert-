import SwiftUI

struct HomeScreen: View {
    // Example state for progress and today’s doses
    @State private var progress: Double = 0.5 // 50%
    private let dosesTaken: Int = 1
    private let totalDoses: Int = 2

    // Sample quick actions and schedule data
    private let actionsData: [QuickAction] = [
        .init(title: "Add Medication", systemImage: "plus.circle.fill", gradient: [.blue, .cyan]),
        .init(title: "Calendar View", systemImage: "calendar", gradient: [.teal, .green]),
        .init(title: "History Log", systemImage: "clock.fill", gradient: [.black.opacity(0.85), .gray]),
        .init(title: "Habit Tracker", systemImage: "chart.bar.fill", gradient: [.orange, .red]),
        .init(title: "Chat with MedBot", systemImage: "bubble.left.and.bubble.right.fill", gradient: [.purple, .indigo]),
        .init(title: "Refill Reminders", systemImage: "pills.fill", gradient: [.mint, .green])
    ]

    private let sampleSchedule: [ScheduleItem] = [
        .init(time: "08:00", title: "Vitamin D", dose: "1 capsule", color: .orange),
        .init(time: "12:30", title: "Amoxicillin", dose: "500 mg", color: .blue),
        .init(time: "21:00", title: "Melatonin", dose: "3 mg", color: .purple)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ProgressCard(progress: progress, dosesTaken: dosesTaken, totalDoses: totalDoses)

                QuickActionsGrid(actions: actionsData) { action in
                    // TODO: Hook up navigation or actions
                    print("Tapped action: \(action.title)")
                }

                ScheduleSection(items: sampleSchedule) {
                    // TODO: See all schedule action
                    print("See All schedule")
                }
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.cyan.opacity(0.95),
                    Color.blue.opacity(0.95),
                    Color.indigo.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Daily Progress")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { /* Notifications */ } label: { Image(systemName: "bell") }
                Button { /* Settings */ } label: { Image(systemName: "gearshape") }
            }
        }
    }
}

// MARK: - Progress Card

private struct ProgressCard: View {
    var progress: Double
    var dosesTaken: Int
    var totalDoses: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 16) {
                Text("Daily Progress")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))

                HStack(alignment: .center) {
                    ZStack {
                        ProgressRing(progress: progress)
                            .frame(width: 150, height: 150)

                        VStack(spacing: 4) {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("\(dosesTaken) of \(totalDoses) doses")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    Spacer()
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
    }
}

private struct ProgressRing: View {
    var progress: Double // 0.0 ... 1.0
    var lineWidth: CGFloat = 16

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: max(0, min(progress, 1)))
                .stroke(
                    AngularGradient(
                        colors: [.white, .white.opacity(0.7), .white],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

// MARK: - Quick Actions

private struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let gradient: [Color]
}

private struct QuickActionsGrid: View {
    let actions: [QuickAction]
    var onAction: (QuickAction) -> Void

    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 2)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(actions) { action in
                    Button {
                        onAction(action)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: action.systemImage)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(.white.opacity(0.15), in: .circle)

                            Text(action.title)
                                .font(.headline)
                                .foregroundStyle(.white)

                            Spacer(minLength: 0)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(LinearGradient(colors: action.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                    }
                    .buttonStyle(.plain)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                }
            }
        }
    }
}

// MARK: - Schedule

private struct ScheduleItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let dose: String
    let color: Color
}

private struct ScheduleSection: View {
    let items: [ScheduleItem]
    var onSeeAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today’s Schedule")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Button("See All") { onSeeAll() }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.95))
            }

            VStack(spacing: 12) {
                ForEach(items) { item in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(item.color)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "pills.fill")
                                    .foregroundStyle(.white)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(item.dose)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.85))
                        }

                        Spacer()
                        Text(item.time)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.95))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.white.opacity(0.15))
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
