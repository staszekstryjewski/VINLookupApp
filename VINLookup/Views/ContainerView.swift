import SwiftUI

/// A protocol representing a container view that can hold and display content of type `Content`.
///
/// Conforming types must implement an initializer that accepts a closure providing the content of the view.
protocol ContainerView: View {

    associatedtype Content

    /// Initializes a new container view with the provided content.
    ///
    /// - Parameter content: A closure that returns the content to be displayed in the container view.
    init(content: @escaping () -> Content)
}

extension ContainerView {

    /// A convenience initializer for the `ContainerView` protocol, using the `@ViewBuilder` attribute to create content.
    ///
    /// - Parameter content: A closure that returns the content to be displayed in the container view.
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.init(content: content)
    }
}

/// A container view that includes a dismissable toolbar with a "Dismiss" button.
///
/// This view wraps around the provided `Content` and displays a toolbar with a button to dismiss the view.
///
/// Conforms to the `ContainerView` protocol.
struct DismissableToolabarContainerView<Content: View>: ContainerView {
    @Environment(\.dismiss) private var dismiss

    var content: () -> Content

    /// Initializes a new `DismissableToolabarContainerView` with the provided content.
    ///
    /// - Parameter content: A closure that returns the content to be displayed in the container view.
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            content()
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                })
        }
    }
}
