import Testing
import Foundation

import VehicleLookup

@testable import VINLookup


final class VinLookupViewModelTests {

    private var service: MockService!
    private var sut: VinLookupViewModel!
    private var store: StoreSpy!

    init() {
        self.service = MockService()
        self.store = StoreSpy()
        self.sut = VinLookupViewModel(vinService: service, store: AnyStore(store))
        sut.vinString = "12345678901234567"
    }

    deinit {
        service = nil
        store = nil
        sut = nil
    }

    @Test("Verify load data from service and save to store")
    func testLoadDataSuccess() async {
        let expected = Vehicle.sample
        service.mocked = expected

        await confirmation { saved in
            store.onSave = {
                saved()
            }
            await sut.performSearch()
        }

        #expect(self.sut.errorMessage == nil)
        #expect(!self.store.results.isEmpty)
        #expect(self.sut.vehicle == expected)
    }

    @Test("Verify error message on service error")
    func testLoadDataFail() async {
        await sut.performSearch()

        #expect(self.sut.errorMessage != nil)
        #expect(self.store.results.isEmpty)
        #expect(self.sut.vehicle == nil)
    }
}

// MARK: - Helpers
private class MockService: VehicleLookupService {

    var mocked: Vehicle?

    func vehicleData(vin: String) async throws -> VehicleLookup.Vehicle {
        guard let mocked else { throw NSError() }
        return mocked
    }
}

private class StoreSpy: Store {

    var results: [RecentSearch] = []
    var onSave: (() -> Void)?

    func add(_ item: VINLookup.RecentSearch) async throws {
        results.append(item)
        onSave?()
    }

    func load() async throws -> [RecentSearch] { [] }
}
