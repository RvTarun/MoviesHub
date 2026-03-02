import SwiftUI
import FirebaseCore

@main
@MainActor struct MoviesHubApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView(auth: AuthViewModel())
        }
    }
}
