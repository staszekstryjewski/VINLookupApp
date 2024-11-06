import Foundation

/// A service that provides vehicle data based on a vehicle identification number (VIN).
public protocol VehicleLookupService {

    /// Retrieves data for a vehicle given its VIN.
    ///
    /// - Parameter vin: The vehicle identification number for which to fetch data.
    /// - Returns: A `Vehicle` object containing information about the vehicle.
    /// - Throws: An error if data retrieval fails.
    func vehicleData(vin: String) async throws -> Vehicle
}

/// A service that extracts text content from image data using OCR (Optical Character Recognition).
public protocol ImageToTextService {

    /// Processes image data and returns extracted text in a structured format.
    ///
    /// - Parameter imageData: The binary data of the image to process.
    /// - Returns: An array of `ImageToText` objects representing recognized text within the image.
    /// - Throws: An error if text extraction fails.
    func imageToText(from imageData: Data) async throws -> [ImageToText]
}
