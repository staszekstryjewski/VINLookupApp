import Foundation

/// A struct representing text extracted from an image using Optical Character Recognition (OCR).
public struct ImageToText: Decodable {

    /// The extracted text from the image.
    public let text: String
}

extension ImageToText: Sendable {}

extension ImageToText: Equatable {}
