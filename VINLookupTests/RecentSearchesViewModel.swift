import Testing
import Foundation

@testable import VINLookup

class RecentSearchesViewModelTests {
    private var sut: RecentSearchesViewModel!
    private var mockStore: MockStore!

    init() {
        mockStore = MockStore()
    }

    deinit {
        mockStore = nil
        sut = nil
    }

    @Test("Verify if shows data loaded from store")
    func testLoadDataSuccess() async {
        let expectedSearches = [RecentSearch(vehicle: .sample, date: Date())]
        mockStore.mockData = expectedSearches
        sut = RecentSearchesViewModel(store: AnyStore(mockStore))

        await sut.loadData()

        #expect(sut.recentSearches.elementsEqual(expectedSearches), "Expected recent searches to match mock data")
        #expect(sut.errorMessage == nil, "Expected no error message on successful load")
    }

    @Test("Verify if shows error message on store failure")
    func testLoadDataFailure() async {
        mockStore.shouldFail = true
        sut = RecentSearchesViewModel(store: AnyStore(mockStore))

        await sut.loadData()

        #expect(sut.errorMessage == "Error loading recent searches.", "Expected error message on load failure")
        #expect(sut.recentSearches.elementsEqual([]), "Expected recent searches to be empty on load failure")
    }
}

// MARK: - Helpers
private struct MockStore: Store {

    var shouldFail = false
    var mockData: [RecentSearch] = []

    func add(_ item: VINLookup.RecentSearch) async throws { }

    func load() async throws -> [RecentSearch] {
        if shouldFail {
            throw NSError(domain: "TestError", code: -1)
        }
        return mockData
    }
}
