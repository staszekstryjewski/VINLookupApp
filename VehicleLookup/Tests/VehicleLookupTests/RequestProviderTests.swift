import Testing
import Foundation

@testable import VehicleLookup

final class RequestProviderTests {

    private var requestProvider: RequestProvider!
    private let apiToken = "testApiToken123"

    init() {
        requestProvider = RequestProvider(apiToken: apiToken)
    }

    deinit {
        requestProvider = nil
    }

    @Test("Verify the VIN request is created correctly")
    func testVinlookupRequest() throws {
        let endpoint = APIEndpoint.vinlookup(vin: "1HGCM82633A123456")
        let request = try requestProvider.request(for: endpoint)

        #expect(request.url?.absoluteString == "https://api.api-ninjas.com/v1/vinlookup?vin=1HGCM82633A123456")
        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.value(forHTTPHeaderField: "X-Api-Key") == apiToken)
    }

    @Test("Verify the image-to-text request is created correctly")
    func testImageToTextRequest() throws {
        let imageData = Data([0x89, 0x50, 0x4E, 0x47])
        let endpoint = APIEndpoint.imageToText(image: imageData)
        let request = try requestProvider.request(for: endpoint)

        #expect(request.url?.absoluteString == "https://api.api-ninjas.com/v1/imagetotext")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type")?.contains("multipart/form-data") ?? false)
        #expect(request.value(forHTTPHeaderField: "X-Api-Key") == apiToken)

        #expect(request.httpBody != nil)
        if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
            #expect(bodyString.contains("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\""))
            #expect(bodyString.contains("Content-Type: image/jpeg"))
        }
    }
}
