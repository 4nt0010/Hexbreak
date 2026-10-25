import SwiftUI

/// Respirazione guidata: il fumo del calderone si gonfia (inspira) e si sgonfia (espira).
struct BreathingGame: View {
    private let totalCycles = 5
    private let inhale: Double = 4
    private let exhale: Double = 6

    @State private var cycle = 0
    @State private var expanded = false
    @State private var running = false
    @State private var finished = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [.purple.opacity(0.8), .mint.opacity(0.2)],
                                         center: .center, startRadius: 10, endRadius: 160))
                    .frame(width: 280, height: 280)
                    .scaleEffect(expanded ? 1.0 : 0.45)
                    .blur(radius: 8)
                Text("🧪").font(.system(size: 60))
            }
            Text(statusText)
                .font(.title2.bold())
            Text("Ciclo \(min(cycle + 1, totalCycles)) di \(totalCycles)")
                .foregroundStyle(.secondary)
            Spacer()
            if !running {
                Button(finished ? "Ancora una volta" : "Inizia") { Task { await run() } }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
        .padding()
        .navigationTitle("Respiro del calderone")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusText: String {
        if finished { return "Ben fatto! +2 🍄" }
        if !running { return "Segui il fumo con il respiro" }
        return expanded ? "Inspira…" : "Espira…"
    }

    private func run() async {
        running = true
        finished = false
        for i in 0..<totalCycles {
            cycle = i
            withAnimation(.easeInOut(duration: inhale)) { expanded = true }
            try? await Task.sleep(for: .seconds(inhale))
            withAnimation(.easeInOut(duration: exhale)) { expanded = false }
            try? await Task.sleep(for: .seconds(exhale))
        }
        Rewards.addIngredients(2)
        running = false
        finished = true
    }
}
