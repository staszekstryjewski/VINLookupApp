import Foundation

import VehicleLookup

final class RecentSearchesViewModel: ObservableObject {

    @Published var recentSearches: [RecentSearch] = []
    @Published var errorMessage: String?
    @Published var selectedVehicle: Vehicle?

    private let store: AnyStore<RecentSearch>

    init(store: AnyStore<RecentSearch>) {
        self.store = store
    }

    @MainActor
    func loadData() async {
        do {
            recentSearches = try await store.load()
        } catch {
            errorMessage = "Error loading recent searches."
        }
    }
}
