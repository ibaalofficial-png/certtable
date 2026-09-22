import SwiftUI
import SwiftData

@main
struct CertLedgerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Sale.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
