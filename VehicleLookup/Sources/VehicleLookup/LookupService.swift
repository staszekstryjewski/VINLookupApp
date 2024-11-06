import Foundation

/// An asynchronous lookup service that manages network requests and prevents actor reentrancy issues,
/// specifically avoiding multiple concurrent requests for the same asset.
///
/// `LookupService` caches and tracks the loading state of each request by its identifier to ensure
/// that only one request per asset is processed at a time.
public final actor LookupService {

    /// Represents the loading state of a request, which can be either in progress or completed.
    private enum LoadingState<T> {
        case loading(Task<T, Error>)
        case completed(T)
    }

    private var requestStates: [String: Any] = [:]
    private let service: Networking

    /// Initializes a new `LookupService` with the specified URL session and API key.
    ///
    /// - Parameters:
    ///   - session: The `URLSession` instance used to execute requests.
    ///   - apiToken: The API key for authenticating requests.
    public init(session: URLSession, apiToken: String) {
        service = APIClient(session: session, requestProvider: RequestProvider(apiToken: apiToken))
    }
}

// MARK: - Private
private extension LookupService {

    func getData<T: Decodable & Sendable>(for endpoint: APIEndpoint, key: String) async throws -> T {
        if let state = requestStates[key] as? LoadingState<T> {
            switch state {
            case let .loading(task):
                return try await task.value
            case let .completed(data):
                return data
            }
        }

        let task = Task<T, Error> {
            try await retry { [weak self] in
                guard let self else {
                    throw LookupServiceError.otherError
                }
                return try await self.service.performRequest(endpoint)
            }
        }

        requestStates[key] = LoadingState<T>.loading(task)

        do {
            let data = try await task.value
            requestStates[key] = LoadingState.completed(data)
            return data
        } catch {
            requestStates[key] = nil
            throw error
        }
    }

    func retry<T: Sendable>(_ block: @escaping () async throws -> T, retries: Int = 3) async throws -> T {
        var delay = 1
        var attempt = 0

        while attempt < retries {
            do {
                return try await block()
            } catch LookupServiceError.rateLimitExceeded {
                attempt += 1
                if attempt == retries { throw LookupServiceError.rateLimitExceeded }
                try await Task.sleep(for: .seconds(delay))
                delay *= 2
            }
        }
        return try await block()
    }
}

// MARK: - LookupService+VehicleLookupService
extension LookupService: VehicleLookupService {

    public func vehicleData(vin: String) async throws -> Vehicle {
        try await getData(for: .vinlookup(vin: vin), key: vin)
    }
}

// MARK: - LookupService+ImageToTextService
extension LookupService: ImageToTextService {

    public func imageToText(from imageData: Data) async throws -> [ImageToText] {
        let key = imageData.hashValue.description
        return try await getData(for: .imageToText(image: imageData), key: key)
    }
}
