import Foundation

/// A protocol that defines a generic interface for validating values of a specific type.
/// Conforming types must provide validation logic that throws an error if validation fails.
public protocol Validator {

    associatedtype T
    func validate(_ value: T) throws
}
