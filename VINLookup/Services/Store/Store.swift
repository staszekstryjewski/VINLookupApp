import Foundation

/// A protocol that defines basic operations for a store that handles Codable items.
///
/// Conforming types must implement methods for loading and adding items of a specific type.
protocol Store {

    /// The type of items managed by the store. It must conform to `Codable`.
    associatedtype T: Codable

    /// Loads and returns an array of items from the store.
    ///
    /// - Returns: An array of items of type `T`.
    /// - Throws: An error if loading fails.
    func load() async throws -> [T]

    /// Adds an item to the store.
    ///
    /// - Parameter item: The item to be added to the store.
    /// - Throws: An error if adding the item fails.
    func add(_ item: T) async throws
}


struct AnyStore<T: Codable>: Store {

    private let _load: () async throws -> [T]
    private let _add: (T) async throws -> Void

    /// Initializes an `AnyStore` by wrapping a given store instance.
    ///
    /// - Parameter store: The store to wrap. It must handle items of the same type `T`.
    init<S: Store>(_ store: S) where S.T == T {
        _load = store.load
        _add = store.add
    }

    /// Loads items from the wrapped store.
    ///
    /// - Returns: An array of items of type `T`.
    /// - Throws: An error if loading fails.
    public func load() async throws -> [T] {
        try await _load()
    }

    /// Adds an item to the wrapped store.
    ///
    /// - Parameter item: The item to be added.
    /// - Throws: An error if adding fails.
    public func add(_ item: T) async throws {
        try await _add(item)
    }
}
