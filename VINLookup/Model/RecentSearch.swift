import Foundation

import VehicleLookup

/// A struct representing a recent search, which contains a `Vehicle` and the date when the search was performed.
struct RecentSearch: Codable {
    let vehicle: Vehicle
    let date: Date
}

extension RecentSearch: Identifiable {
    var id: String { vehicle.vin }
}

extension RecentSearch: Equatable {}
