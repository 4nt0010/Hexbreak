import ActivityKit
import Foundation

enum SessionPhase: String, Codable, Hashable {
    case work, rest
}

enum WitchMood: String, Codable, Hashable {
    case happy, suspicious, furious, sleeping

    var face: String {
        switch self {
        case .happy: return "🧙‍♀️"
        case .suspicious: return "🤨"
        case .furious: return "😡"
        case .sleeping: return "😴"
        }
    }

    var label: String {
        switch self {
        case .happy: return "Contenta"
        case .suspicious: return "Sospettosa"
        case .furious: return "Furiosa"
        case .sleeping: return "Sonnecchia"
        }
    }
}

struct HexbreakAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var phase: SessionPhase
        var mood: WitchMood
        var message: String
        var start: Date
        var end: Date
        var snoozes: Int
    }

    var workMinutes: Int
    var breakMinutes: Int
}
