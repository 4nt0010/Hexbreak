import SwiftUI

/// Simon Says con le rune: guarda la sequenza e ripetila.
struct RuneMemoryGame: View {
    private let runes = ["ᚠ", "ᚢ", "ᚦ", "ᚨ", "ᚱ", "ᚲ"]
    private let maxLevel = 6

    @State private var sequence: [Int] = []
    @State private var inputIndex = 0
    @State private var highlighted: Int?
    @State private var showing = false
    @State private var message = "Memorizza la sequenza di rune"
    @State private var playing = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        VStack(spacing: 28) {
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(minHeight: 50)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(runes.indices, id: \.self) { index in
                    Button { tap(index) } label: {
                        Text(runes[index])
                            .font(.system(size: 44, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(highlighted == index ? Color.mint : Color.purple.opacity(0.35))
                            )
                            .foregroundStyle(.white)
                    }
                    .disabled(showing || !playing)
                }
            }

            Text("Livello \(max(sequence.count, 1)) di \(maxLevel)")
                .foregroundStyle(.secondary)

            if !playing {
                Button("Inizia") { Task { await newGame() } }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
        }
        .padding()
        .navigationTitle("Memory delle rune")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func newGame() async {
        sequence = []
        playing = true
        await nextLevel()
    }

    private func nextLevel() async {
        sequence.append(Int.random(in: 0..<runes.count))
        inputIndex = 0
        message = "Osserva…"
        showing = true
        try? await Task.sleep(for: .milliseconds(600))
        for rune in sequence {
            withAnimation(.easeIn(duration: 0.15)) { highlighted = rune }
            try? await Task.sleep(for: .milliseconds(550))
            withAnimation(.easeOut(duration: 0.15)) { highlighted = nil }
            try? await Task.sleep(for: .milliseconds(250))
        }
        showing = false
        message = "Tocca a te!"
    }

    private func tap(_ index: Int) {
        flash(index)
        guard index == sequence[inputIndex] else {
            message = "Runa sbagliata! La strega ridacchia. 🐸"
            playing = false
            return
        }
        inputIndex += 1
        guard inputIndex == sequence.count else { return }

        if sequence.count >= maxLevel {
            message = "Incantesimo completato! +3 🍄"
            Rewards.addIngredients(3)
            playing = false
        } else {
            message = "Giusto!"
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                await nextLevel()
            }
        }
    }

    private func flash(_ index: Int) {
        highlighted = index
        Task {
            try? await Task.sleep(for: .milliseconds(200))
            if highlighted == index { highlighted = nil }
        }
    }
}
