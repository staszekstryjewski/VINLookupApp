import SwiftUICore

/// An extension to `Binding` where the `Value` is a `Bool`.
///
/// This extension allows creating a `Binding<Bool>` from a `Binding<T?>`, where `T` is an optional type.
/// It will convert the optional value to a `Bool` based on whether it is `nil` or not, and provide a mechanism
/// to set the optional value back to `nil` when the `Bool` is set to `false`.
extension Binding where Value == Bool {

    /// Creates a `Binding<Bool>` from a `Binding<T?>`.
    ///
    /// - Parameter value: A `Binding` to an optional value (`T?`).
    ///
    /// The `Bool` binding will be `true` when the optional value is non-`nil` and `false` when it is `nil`.
    /// Setting the `Bool` to `false` will set the original optional value to `nil`.
    /// This is useful in scenarios where you want to represent the presence or absence of a value (e.g., to toggle a UI element based on whether the optional value is set).
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
