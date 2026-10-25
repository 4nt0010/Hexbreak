import SwiftUI

@main
struct HexbreakApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear { Notifications.requestPermission() }
        }
    }
}
