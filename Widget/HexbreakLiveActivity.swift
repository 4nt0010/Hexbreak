import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

private extension WitchMood {
    var color: Color {
        switch self {
        case .happy: return .purple
        case .suspicious: return .orange
        case .furious: return .red
        case .sleeping: return .mint
        }
    }
}

struct HexbreakLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HexbreakAttributes.self) { context in
            LockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let state = context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(spacing: 2) {
                        Text(state.mood.face).font(.system(size: 34))
                        Text(state.mood.label)
                            .font(.caption2)
                            .foregroundStyle(state.mood.color)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(state.phase == .work ? "Lavoro" : "Pausa")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        TimerText(state: state)
                            .font(.title3.bold())
                            .foregroundStyle(state.mood.color)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(state.message)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ActionButtons(state: state)
                }
            } compactLeading: {
                Text(state.mood.face)
            } compactTrailing: {
                TimerText(state: state)
                    .frame(maxWidth: 44)
                    .foregroundStyle(state.mood.color)
            } minimal: {
                Text(state.mood.face)
            }
            .keylineTint(state.mood.color)
        }
    }
}

private struct TimerText: View {
    let state: HexbreakAttributes.ContentState

    var body: some View {
        Text(timerInterval: state.start...state.end, countsDown: true)
            .monospacedDigit()
            .multilineTextAlignment(.trailing)
    }
}

private struct ActionButtons: View {
    let state: HexbreakAttributes.ContentState

    var body: some View {
        HStack(spacing: 8) {
            if state.phase == .work {
                Button(intent: StartBreakIntent()) {
                    Label("Pausa", systemImage: "cup.and.saucer.fill")
                        .frame(maxWidth: .infinity)
                }
                .tint(.mint)
                Button(intent: SnoozeIntent()) {
                    Label("+10 min", systemImage: "clock.arrow.circlepath")
                        .frame(maxWidth: .infinity)
                }
                .tint(state.snoozes >= 2 ? .red : .orange)
            } else {
                Button(intent: BackToWorkIntent()) {
                    Label("Torno al lavoro", systemImage: "flame.fill")
                        .frame(maxWidth: .infinity)
                }
                .tint(.purple)
            }
        }
        .font(.caption.bold())
        .buttonStyle(.borderedProminent)
    }
}

private struct LockScreenView: View {
    let state: HexbreakAttributes.ContentState

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Text(state.mood.face).font(.system(size: 40))
                VStack(alignment: .leading, spacing: 4) {
                    Text(state.message)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    ProgressView(timerInterval: state.start...state.end, countsDown: true) {
                        EmptyView()
                    } currentValueLabel: {
                        EmptyView()
                    }
                    .tint(state.mood.color)
                }
                TimerText(state: state)
                    .font(.title2.bold())
                    .foregroundStyle(state.mood.color)
                    .frame(width: 70)
            }
            ActionButtons(state: state)
        }
    }
}
