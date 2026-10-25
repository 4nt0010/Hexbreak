import AppIntents

// Pulsanti premibili direttamente nella Dynamic Island (iOS 17+).

struct StartBreakIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Vado in pausa"

    func perform() async throws -> some IntentResult {
        await HexbreakController.startBreak()
        return .result()
    }
}

struct SnoozeIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Ancora 10 minuti"

    func perform() async throws -> some IntentResult {
        await HexbreakController.snooze()
        return .result()
    }
}

struct BackToWorkIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Torno al lavoro"

    func perform() async throws -> some IntentResult {
        await HexbreakController.backToWork()
        return .result()
    }
}
