import Foundation

/// An actor that manages the storage and retrieval of recent search data in a file.
/// This implementation conforms to the `Store` protocol, specifically for handling `RecentSearch` items.
///
/// It supports loading recent searches from disk, adding new searches, and saving to disk.
final actor RecentSearchesStore: Store {

    enum StoreError: Error {
        case errorSaving
        case errorLoading
    }

    private let NO_PREVIOUS_STORE_CODE = 260
    private let fileManager = FileManager.default
    private let filename: String
    private var recentSearches: [RecentSearch] = []

    private var fileURL: URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(filename)
    }

    init(filename: String) {
        self.filename = filename

        Task {
            try await load()
        }
    }

    /// Loads recent searches from disk.
    ///
    /// - Returns: An array of `RecentSearch` items loaded from the file.
    /// - Throws: `StoreError.errorLoading` if loading fails.
    func load() async throws -> [RecentSearch] {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let searches = try decoder.decode([RecentSearch].self, from: data)
            self.recentSearches = searches
            return searches
        } catch {
            guard (error as NSError).code != NO_PREVIOUS_STORE_CODE else { return [] }
            throw StoreError.errorLoading
        }
    }

    /// Adds a new recent search to the store or updates an existing search.
    ///
    /// - Parameter item: The `RecentSearch` to be added to the store.
    /// - Throws: `StoreError.errorSaving` if saving to disk fails.
    func add(_ item: RecentSearch) async throws {
        if let index = recentSearches.firstIndex(where: { $0.vehicle.vin == item.vehicle.vin }) {
            recentSearches[index] = item
        } else {
            recentSearches.append(item)
        }
        recentSearches.sort { $0.date > $1.date }

        try await saveToDisk(recentSearches)
    }

    private func saveToDisk(_ items: [RecentSearch]) async throws {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(items)
            try data.write(to: fileURL)
        } catch {
            throw StoreError.errorSaving
        }
    }
}

extension Store where Self == RecentSearchesStore {
    func asAnyStore() -> AnyStore<RecentSearch> {
        AnyStore(self)
    }
}
