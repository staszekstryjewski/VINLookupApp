import SwiftUI

/// A custom input field view that validates user input based on a provided `Validator`,
/// displaying an error message when validation fails.
///
/// `ValidatedInputField` provides a text field with real-time validation and an optional
/// callback for handling validation state changes.
public struct ValidatedInputField: View {

    /// The bound text input from the user.
    @Binding var query: String

    private let validator: AnyValidator<String>
    private let placeholder: String
    private let errorMessage: String
    private let onValidationChange: ((Bool) -> Void)?

    @State private var shouldShowError = false

    /// Initializes a new `ValidatedInputField` with specified properties.
    ///
    /// - Parameters:
    ///   - query: A binding to the input text.
    ///   - validator: The `AnyValidator` instance used to validate the input.
    ///   - placeholder: The placeholder text for the text field.
    ///   - errorMessage: The error message displayed when validation fails.
    ///   - onValidationChange: An optional callback that reports validation success or failure.
    public init(
        query: Binding<String>,
        validator: AnyValidator<String>,
        placeholder: String, errorMessage: String,
        onValidationChange: ((Bool) -> Void)?) {
            self._query = query
            self.validator = validator
            self.placeholder = placeholder
            self.errorMessage = errorMessage
            self.onValidationChange = onValidationChange
        }

    public var body: some View {
        VStack(spacing: 4) {
            inputField
            errorText
                .opacity(shouldShowError ? 1 : 0)
        }
        .onChange(of: query) { _, newValue in
            validateInput()
        }
    }

    private var inputField: some View {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $query)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.characters)
                .padding(.horizontal, 16)

            clearButton
        }
    }

    private var clearButton: some View {
        Button {
            clearInput()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.gray.opacity(query.isEmpty ? 0 : 1))
        }
        .padding(.trailing, 24)
        .disabled(query.isEmpty)
    }

    private var errorText: some View {
        Text(errorMessage)
            .foregroundStyle(.red)
            .font(.caption)
    }

    private func validateInput() {
        do {
            try validator.validate(query)
            shouldShowError = false
            onValidationChange?(true)
        } catch {
            shouldShowError = !query.isEmpty
            onValidationChange?(false)
        }
    }

    private func clearInput() {
        query = ""
        onValidationChange?(false)
    }
}
