import Foundation

import ValidatedInputComponent
import VehicleLookup

final class VinLookupViewModel: ObservableObject {

    @Published var vinString: String = ""
    @Published var errorMessage: String?
    @Published var vehicle: Vehicle?
    @Published var isLoading: Bool = false

    private let vinService: VehicleLookupService
    private let store: AnyStore<RecentSearch>

    init(
        vinService: VehicleLookupService,
        store: AnyStore<RecentSearch>) {
            self.vinService = vinService
            self.store = store
        }

    @MainActor
    func performSearch() async {
        guard let vinQuery = vinString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let vehicle = try await vinService.vehicleData(vin: vinQuery)
            try await store.add(RecentSearch(vehicle: vehicle, date: Date()))
            self.vehicle = vehicle
        } catch {
            errorMessage = "Something went wrong. Try again later..."
        }
    }
}
