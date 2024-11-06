import Foundation

/// A struct representing a vehicle, with properties parsed from a Vehicle Identification Number (VIN).
///
/// The `Vehicle` struct is designed to hold data extracted from a VIN, including country, region,
/// and various components of the VIN structure.
public struct Vehicle: Codable {
    
    public let vin: String
    public let country: String
    public let region: String
    public let wmi: String
    public let vds: String
    public let vis: String
    public let year: Int

    /// Initializes a new `Vehicle` object with the provided details.
    public init(vin: String, country: String, region: String, wmi: String, vds: String, vis: String, year: Int) {
        self.vin = vin
        self.country = country
        self.region = region
        self.wmi = wmi
        self.vds = vds
        self.vis = vis
        self.year = year
    }
}

extension Vehicle: Identifiable {
    public var id: String { vin }
}

extension Vehicle: Sendable {}

extension Vehicle: Equatable {}
