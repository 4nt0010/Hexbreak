import ActivityKit
import Foundation
import UserNotifications

/// Gestisce la Live Activity (Dynamic Island) e i progressi del gioco.
enum HexbreakController {
    typealias State = HexbreakAttributes.ContentState

    static var current: Activity<HexbreakAttributes>? {
        Activity<HexbreakAttributes>.activities.first
    }

    // MARK: - Sessioni

    static func startWork(workMinutes: Int, breakMinutes: Int) async throws {
        await stop()
        let now = Date()
        let state = State(
            phase: .work,
            mood: .happy,
            message: WitchLines.pick(WitchLines.start),
            start: now,
            end: now.addingTimeInterval(Double(workMinutes * 60)),
            snoozes: 0
        )
        let attributes = HexbreakAttributes(workMinutes: workMinutes, breakMinutes: breakMinutes)
        _ = try Activity.request(
            attributes: attributes,
            content: .init(state: state, staleDate: state.end),
            pushType: nil
        )
        Notifications.schedule(at: state.end, body: WitchLines.pick(WitchLines.timeUp))
    }

    static func startBreak() async {
        guard let activity = current else { return }
        let now = Date()
        let state = State(
            phase: .rest,
            mood: .sleeping,
            message: WitchLines.pick(WitchLines.rest),
            start: now,
            end: now.addingTimeInterval(Double(activity.attributes.breakMinutes * 60)),
            snoozes: 0
        )
        await activity.update(.init(state: state, staleDate: state.end))
        Rewards.addIngredients(1)
        Rewards.breaksTaken += 1
        Notifications.schedule(at: state.end, body: WitchLines.pick(WitchLines.restOver))
    }

    static func snooze() async {
        guard let activity = current else { return }
        var state = activity.content.state
        let now = Date()
        state.snoozes += 1
        state.mood = state.snoozes >= 3 ? .furious : .suspicious
        state.message = WitchLines.pick(state.snoozes >= 3 ? WitchLines.furious : WitchLines.snooze)
        state.start = now
        state.end = now.addingTimeInterval(10 * 60)
        await activity.update(.init(state: state, staleDate: state.end))
        Notifications.schedule(at: state.end, body: WitchLines.pick(WitchLines.furious))
    }

    static func backToWork() async {
        guard let activity = current else { return }
        let now = Date()
        let state = State(
            phase: .work,
            mood: .happy,
            message: WitchLines.pick(WitchLines.start),
            start: now,
            end: now.addingTimeInterval(Double(activity.attributes.workMinutes * 60)),
            snoozes: 0
        )
        await activity.update(.init(state: state, staleDate: state.end))
        Notifications.schedule(at: state.end, body: WitchLines.pick(WitchLines.timeUp))
    }

    /// Chiamata quando l'app torna in primo piano: se il tempo è scaduto, la strega si accorge.
    static func refreshIfOverdue() async {
        guard let activity = current else { return }
        var state = activity.content.state
        guard state.phase == .work, Date() >= state.end, state.mood == .happy else { return }
        state.mood = .suspicious
        state.message = WitchLines.pick(WitchLines.timeUp)
        await activity.update(.init(state: state, staleDate: nil))
    }

    static func stop() async {
        Notifications.cancelAll()
        for activity in Activity<HexbreakAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}

// MARK: - Progressi

enum Rewards {
    private static let defaults = UserDefaults.standard

    static var ingredients: Int {
        get { defaults.integer(forKey: "ingredients") }
        set { defaults.set(newValue, forKey: "ingredients") }
    }

    static var breaksTaken: Int {
        get { defaults.integer(forKey: "breaksTaken") }
        set { defaults.set(newValue, forKey: "breaksTaken") }
    }

    static func addIngredients(_ amount: Int) {
        ingredients += amount
    }
}

// MARK: - Notifiche locali

enum Notifications {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func schedule(at date: Date, body: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let interval = max(1, date.timeIntervalSinceNow)
        let content = UNMutableNotificationContent()
        content.title = "La strega ti chiama"
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        center.add(UNNotificationRequest(identifier: "hexbreak", content: content, trigger: trigger))
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
