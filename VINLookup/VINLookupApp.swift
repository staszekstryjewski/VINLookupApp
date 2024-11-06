import SwiftUI

@main
struct VINLookupApp: App {

    @StateObject var model: AppModel = .init()

    var body: some Scene {
        WindowGroup {
            MainTabView(model: model)
        }
    }
}

private extension AppModel {
    convenience init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 20
        sessionConfiguration.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfiguration)
        self.init(
            session: session,
            apiToken: "YOUR_TOKEN_HERE",
            storeFileName: "recentSearches.json")
    }
}
