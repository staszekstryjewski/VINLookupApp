import Foundation

/// An enumeration representing different API endpoints for the `LookupService`.
///
/// Each case corresponds to a specific endpoint for network requests
enum APIEndpoint {

    case vinlookup(vin: String)
    case imageToText(image: Data)

    var baseURL: String {
        return "https://api.api-ninjas.com/v1"
    }

    var path: String {
        switch self {
        case .vinlookup: 
            return "/vinlookup"
        case .imageToText:
            return "/imagetotext"
        }
    }

    var method: String {
        switch self {
        case .vinlookup:
            return "GET"
        case .imageToText:
            return "POST"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .vinlookup(vinString):
            return ["vin": vinString]
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}

extension APIEndpoint: Sendable {}
