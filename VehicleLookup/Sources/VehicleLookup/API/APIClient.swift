import Foundation

/// A protocol that defines a network service capable of performing requests and decoding responses.
///
/// Conforming types must provide a method for performing network requests and returning decoded responses.
protocol Networking: Sendable {

    /// Performs a network request for a given `APIEndpoint` and decodes the response into a specified type.
    ///
    /// - Parameter endpoint: The `APIEndpoint` that defines the details of the request.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class APIClient: Networking {

    /// The request provider responsible for creating network requests.
    private let requestProvider: RequestProviding

    /// The URL session used for performing network requests.
    private let session: URLSession

    /// Initializes a new `APIClient` with the given session and API key.
    ///
    /// - Parameters:
    ///   - session: The `URLSession` instance used to execute requests.
    ///   - requestProvider: The request provider responsible for creating network requests.
    init(session: URLSession, requestProvider: RequestProviding) {
        self.session = session
        self.requestProvider = requestProvider
    }
    #warning("@SS update documentation")

    /// Performs a network request and decodes the response into the specified type.
    ///
    /// - Parameter endpoint: The `APIEndpoint` that defines the details of the request.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: A `LookupServiceError` if the request fails, if the response cannot be decoded, or if any other errors occur.
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = try requestProvider.request(for: endpoint)
        let result = try await session.data(for: request)
        let data = try checkResponse(result: result)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw LookupServiceError.decodingError(error)
        }
    }

    /// Checks the response for success or failure, throwing an error if necessary.
    private func checkResponse(result: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = result.response as? HTTPURLResponse else {
            throw LookupServiceError.badResponse
        }

        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200...299:
            return result.data
        case 429:
            throw LookupServiceError.rateLimitExceeded
        default:
            throw LookupServiceError.serverError(statusCode: statusCode)
        }
    }
}
