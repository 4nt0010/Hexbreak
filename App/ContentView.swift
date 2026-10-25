import ActivityKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("ingredients") private var ingredients = 0
    @AppStorage("breaksTaken") private var breaksTaken = 0
    @AppStorage("workMinutes") private var workMinutes = 25
    @AppStorage("breakMinutes") private var breakMinutes = 5
    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { _ in
                let state = HexbreakController.current?.content.state
                List {
                    witchCard(state)
                    sessionSection(state)
                    gamesSection
                    statsSection
                }
            }
            .navigationTitle("Hexbreak")
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(colors: [Color(red: 0.12, green: 0.05, blue: 0.2), .black],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
        .tint(.purple)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await HexbreakController.refreshIfOverdue() }
            }
        }
    }

    // MARK: - Sezioni

    private func witchCard(_ state: HexbreakAttributes.ContentState?) -> some View {
        Section {
            VStack(spacing: 8) {
                Text(state?.mood.face ?? "🧙‍♀️")
                    .font(.system(size: 80))
                Text(state?.message ?? "Avvia una sessione e io ti terrò d'occhio.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                if let state {
                    Text(timerInterval: state.start...state.end, countsDown: true)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text(state.phase == .work ? "Sessione di lavoro" : "Pausa")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private func sessionSection(_ state: HexbreakAttributes.ContentState?) -> some View {
        Section("Sessione") {
            if let state {
                if state.phase == .work {
                    Button("☕️ Vado in pausa") { Task { await HexbreakController.startBreak() } }
                    Button("⏰ Ancora 10 minuti") { Task { await HexbreakController.snooze() } }
                } else {
                    Button("🔥 Torno al lavoro") { Task { await HexbreakController.backToWork() } }
                }
                Button("Termina sessione", role: .destructive) {
                    Task { await HexbreakController.stop() }
                }
            } else {
                Stepper("Lavoro: \(workMinutes) min", value: $workMinutes, in: 5...120, step: 5)
                Stepper("Pausa: \(breakMinutes) min", value: $breakMinutes, in: 1...30)
                Button("🧙‍♀️ Inizia sessione") { start() }
                    .font(.headline)
                if let errorText {
                    Text(errorText).font(.caption).foregroundStyle(.red)
                }
            }
        }
    }

    private var gamesSection: some View {
        Section("Mini-giochi da pausa") {
            NavigationLink("🫧 Respiro del calderone") { BreathingGame() }
            NavigationLink("ᚱ Memory delle rune") { RuneMemoryGame() }
        }
    }

    private var statsSection: some View {
        Section("Bottino") {
            LabeledContent("🍄 Ingredienti", value: "\(ingredients)")
            LabeledContent("☕️ Pause fatte", value: "\(breaksTaken)")
        }
    }

    private func start() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            errorText = "Attiva le Attività in tempo reale in Impostazioni › Hexbreak."
            return
        }
        Task {
            do {
                try await HexbreakController.startWork(workMinutes: workMinutes, breakMinutes: breakMinutes)
                errorText = nil
            } catch {
                errorText = "Non riesco ad avviare la Live Activity: \(error.localizedDescription)"
            }
        }
    }
}
