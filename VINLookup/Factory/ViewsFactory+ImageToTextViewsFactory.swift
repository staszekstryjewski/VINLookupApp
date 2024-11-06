import SwiftUICore

import VehicleLookup

protocol ImageToTextViewsFactory {
    func makeImageToTextView(binding: Binding<String>) -> AnyView
    func makeVehicleDetailsView(vehicle: Vehicle) -> AnyView
}

extension ViewsFactory: ImageToTextViewsFactory {}

final class ViewFactoryForVinLookupView: ObservableObject, ImageToTextViewsFactory {

    private let _makeImageToTextView: (Binding<String>) -> AnyView
    private let _makeVehicleDetailsView: (Vehicle) -> AnyView

    init<F: ImageToTextViewsFactory>(_ factory: F) {
        self._makeImageToTextView = factory.makeImageToTextView
        self._makeVehicleDetailsView = factory.makeVehicleDetailsView
    }

    func makeImageToTextView(binding: Binding<String>) -> AnyView {
        _makeImageToTextView(binding)
    }

    func makeVehicleDetailsView(vehicle: VehicleLookup.Vehicle) -> AnyView {
        _makeVehicleDetailsView(vehicle)
    }
}

extension ViewsFactory {
    func asViewFactoryForVinLookupView() -> ViewFactoryForVinLookupView {
        ViewFactoryForVinLookupView(self)
    }
}
