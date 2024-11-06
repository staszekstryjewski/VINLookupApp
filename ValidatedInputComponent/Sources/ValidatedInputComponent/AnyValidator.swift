import Foundation

/// A type-erased `Validator` that can wrap any validator conforming to the `Validator` protocol,
/// enabling the use of generic validation without specifying a concrete validator type.
///
/// `AnyValidator` allows for storing and passing around validators of different types that validate
/// the same data type, by erasing the specific type of the wrapped validator.
public struct AnyValidator<T>: Validator {

    private let _validate: (T) throws -> Void

    public init<V: Validator>(_ validator: V) where V.T == T {
        _validate = validator.validate
    }

    public func validate(_ value: T) throws {
        try _validate(value)
    }
}
