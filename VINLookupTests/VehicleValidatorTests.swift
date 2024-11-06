import Testing

@testable import VINLookup
@testable import VehicleLookup

final class VehicleValidatorTests {
    var sut = VehicleVINValidator()

    @Test("Verify VehicleVINValidator throws on incorrect VIN", arguments: [
        (vin: "JT3HP10VXW7092383", result: nil),
        (vin: "JT3HP1OVXW7092383", result: VehicleVINValidator.ValidationError.validatationFailed),
        (vin: "JT3HP10VXW7092383X", result: VehicleVINValidator.ValidationError.validatationFailed),
        (vin: "JT3HP10VXW709238", result: VehicleVINValidator.ValidationError.validatationFailed),
        (vin: "JT3HP1QVXW709238", result: VehicleVINValidator.ValidationError.validatationFailed)
    ])
    func testVIN(input: String, expectedError: VehicleVINValidator.ValidationError?) async throws {
        if let expectedError {
            #expect(throws: expectedError) {
                try sut.validate(input)
            }
        } else {
            #expect(try sut.validate(input) != nil, "Expected \(input) to be valid")
        }

    }
}

