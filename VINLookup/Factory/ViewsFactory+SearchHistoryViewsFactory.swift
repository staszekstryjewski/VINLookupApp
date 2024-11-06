import SwiftUICore

import VehicleLookup

protocol SearchHistoryViewsFactory {
    func makeVehicleDetailsView(vehicle: Vehicle) -> AnyView
}

extension ViewsFactory: SearchHistoryViewsFactory {}

final class ViewFacotryForRecentSearchesView: ObservableObject, SearchHistoryViewsFactory {

    private let _makeVehicleDetailsView: (Vehicle) -> AnyView

    init<F: ImageToTextViewsFactory>(_ factory: F) {
        self._makeVehicleDetailsView = factory.makeVehicleDetailsView
    }

    func makeVehicleDetailsView(vehicle: VehicleLookup.Vehicle) -> AnyView {
        _makeVehicleDetailsView(vehicle)
    }
}

extension ViewsFactory {
    func asViewFacotryForRecentSearchesView() -> ViewFacotryForRecentSearchesView {
        ViewFacotryForRecentSearchesView(self)
    }
}
