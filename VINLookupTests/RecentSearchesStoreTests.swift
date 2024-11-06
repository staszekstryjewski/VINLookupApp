import Testing
import Foundation

@testable import VINLookup
@testable import VehicleLookup

final class RecentSearchesStoreTests {

    private let filename: String
    private let sut: RecentSearchesStore

    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(filename)
    }

    init() {
        filename = "test\(Int.random(in: 10...99)).json"
        self.sut = .init(filename: filename)
    }

    deinit {
        try? FileManager.default.removeItem(at: fileURL)
    }

    @Test("Verify if no file returns empty array")
    func loadEmpty() async throws {
        let results = try await sut.load()
        #expect(results.isEmpty)
    }

    @Test("Verify the data is saved")
    func saveData() async throws {
        let empty = try await sut.load()
        #expect(empty.isEmpty)
        
        let date = DateComponents(calendar: .current, year: 2024, month: 11, day: 9, hour: 10, minute: 1, second: 1).date!
        let savedData = RecentSearch(vehicle: Vehicle.sample, date: date)
        try await sut.add(savedData)
        let results = try await sut.load()
        #expect(results == [savedData])
    }

    @Test("Verify the data is updated and sorted")
    func updateData() async throws {
        let creationDate1 = makeDate(y: 2024, mo: 11, d: 8, h: 10, m: 1)
        let savedData1 = RecentSearch(vehicle: Vehicle.sample, date: creationDate1)
        let creationDate2 = makeDate(y: 2024, mo: 11, d: 8, h: 10, m: 2)
        let savedData2 = RecentSearch(vehicle: Vehicle.sample2, date: creationDate2)
        let updatedDate = makeDate(y: 2024, mo: 11, d: 8, h: 10, m: 3)
        let updatedData = RecentSearch(vehicle: Vehicle.sample, date: updatedDate)

        try await sut.add(savedData1)
        try await sut.add(savedData2)
        let results = try await sut.load()
        #expect(results == [savedData2, savedData1])

        try await sut.add(updatedData)
        let updatedResults = try await sut.load()
        try await Task.sleep(for: .seconds(10))
        #expect(updatedResults == [updatedData, savedData2])
    }

    @Test("Verify load from exisitnig file")
    func loadExistingData() async throws {
        let data = """
        [{"vehicle":{"wmi":"WMI","vin":"VIN1234567890VIN0","country":"Japan","vis":"VIS","vds":"VDS","year":2024,"region":"Asia"},"date":"2024-11-08T09:02:00Z"}]
        """.data(using: .utf8)!
        try data.write(to: fileURL)

        let results = try await sut.load()
        #expect(results.count == 1)
    }
}

// MARK: - Helpers
private extension RecentSearchesStoreTests {
    func makeDate(y: Int, mo: Int, d: Int, h: Int, m: Int) -> Date {
        DateComponents(calendar: .current, year: y, month:  mo, day: d, hour: h, minute: m).date!
    }
}

private extension Vehicle {
    static let sample2: Vehicle = .init(vin: "VIN2", country: "Poland", region: "Europe", wmi: "X", vds: "Y", vis: "Z", year: 2021)
}
