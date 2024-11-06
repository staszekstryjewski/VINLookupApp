import Foundation

/// An enumeration representing errors that can occur within the `LookupService` and related network requests.
enum LookupServiceError: Error {
    case badResponse
    case invalidURL
    case rateLimitExceeded
    case decodingError(Error)
    case serverError(statusCode: Int)
    case otherError
}
