import SwiftUI
import FirebaseCore

@main
struct MoviesHubApp: App {
    @StateObject var bookmarkStore = BookmarkStore()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView(auth: AuthViewModel())
                .environmentObject(bookmarkStore)
        }
    }
}
