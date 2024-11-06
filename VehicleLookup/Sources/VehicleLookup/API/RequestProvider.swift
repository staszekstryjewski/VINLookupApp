import Foundation

/// A protocol that defines a service for creating `URLRequest` objects for specific API endpoints.
///
/// Conforming types must provide a method to generate a network request for a given `APIEndpoint`.
protocol RequestProviding: Sendable {

    /// Creates a `URLRequest` for the specified API endpoint.
    ///
    /// - Parameter endpoint: The `APIEndpoint` that defines the details of the request.
    /// - Returns: A `URLRequest` ready to be used for making the network request.
    /// - Throws: An error if the request cannot be created.
    func request(for endpoint: APIEndpoint) throws -> URLRequest
}

/// A struct that provides network requests based on the details of a given `APIEndpoint`.
///
/// The `RequestProvider` implements the `RequestProviding` protocol, creating `URLRequest` objects
/// for different API endpoints. It handles constructing the request URL, adding query parameters, setting
/// headers, and building multipart form data for specific endpoints.
struct RequestProvider: RequestProviding {

    private let tokenHeaderKey: String = "X-Api-Key"
    private let apiToken: String

    /// Initializes a new `RequestProvider` instance.
    init(apiToken: String) {
        self.apiToken = apiToken
    }

    /// Creates a `URLRequest` for the specified `APIEndpoint`.
    ///
    /// - Parameter endpoint: The `APIEndpoint` that defines the details of the request.
    /// - Returns: A configured `URLRequest` for the given API endpoint.
    /// - Throws: An error if the request cannot be created.
    func request(for endpoint: APIEndpoint) throws -> URLRequest {
        guard let baseURL = URL(string: endpoint.baseURL),
              var urlComponents = URLComponents(url: baseURL.appending(path: endpoint.path), resolvingAgainstBaseURL: false) else {
            throw LookupServiceError.invalidURL
        }

        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        }

        guard let url = urlComponents.url else {
            throw LookupServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.setValue(apiToken, forHTTPHeaderField: tokenHeaderKey)

        switch endpoint {
        case .imageToText(let imageData):
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = try createMultipartBody(boundary: boundary, imageData: imageData)

        default:
            break
        }

        return request
    }
}

// MARK: - Private
private extension RequestProvider {

    func createMultipartBody(boundary: String, imageData: Data) throws -> Data {
        var body = Data()
        body.append(try dataFrom("--\(boundary)\r\n"))
        body.append(try dataFrom("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"))
        body.append(try dataFrom("Content-Type: image/jpeg\r\n\r\n"))
        body.append(imageData)
        body.append(try dataFrom("\r\n"))
        body.append(try dataFrom("--\(boundary)--\r\n"))

        return body
    }

    func dataFrom(_ string: String) throws -> Data {
        guard let data = string.data(using: .utf8) else {
            throw LookupServiceError.otherError
        }
        return data
    }
}
