import RegexBuilder

import ValidatedInputComponent

struct VehicleVINValidator: Validator {

    enum ValidationError: Error {
        case validatationFailed
    }

    func validate(_ value: String) throws {
        let reg = Regex {
            Anchor.startOfLine
            Repeat(count: 17) {
                CharacterClass(
                    ("A"..."H"),
                    ("J"..."N"),
                    .anyOf("P"),
                    ("R"..."Z"),
                    ("0"..."9")
                )
            }
            Anchor.endOfLine
        }
        .anchorsMatchLineEndings()
        
        guard let _ = try? reg.firstMatch(in: value) else {
            throw ValidationError.validatationFailed
        }
    }
}

extension Validator where Self == VehicleVINValidator {
    func asAnyValidator() -> AnyValidator<String> {
        AnyValidator(self)
    }
}
