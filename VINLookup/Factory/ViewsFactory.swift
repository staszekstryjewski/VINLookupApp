import Foundation
import SwiftUICore

import ValidatedInputComponent
import VehicleLookup

final class ViewsFactory: ObservableObject {

    let vinService: VehicleLookupService
    let imageToTextService: ImageToTextService
    let validator: AnyValidator<String>
    let store: AnyStore<RecentSearch>

    init(vinService: VehicleLookupService, imageToTextService: ImageToTextService, validator: AnyValidator<String>, store: AnyStore<RecentSearch>) {
        self.vinService = vinService
        self.imageToTextService = imageToTextService
        self.validator = validator
        self.store = store
    }

    func makeImageToTextView(binding: Binding<String>) -> AnyView {
        let imageToTextVM = ImageToTextViewModel(service: imageToTextService)
        return AnyView(
            DismissableToolabarContainerView {
                ImageToTextView(viewModel: imageToTextVM, recognizedVIN: binding)
            }
        )
    }

    func makeVehicleDetailsView(vehicle: Vehicle) -> AnyView {
        return AnyView(
            DismissableToolabarContainerView {
                VehicleDetailsView(vehicle: vehicle)
            }
        )
    }

    func makeVinLookupView() -> AnyView {
        let vm = VinLookupViewModel(
            vinService: vinService,
            store: store)
        return AnyView(
            VinLookupView(
                viewModel: vm,
                validator: validator)
            .environmentObject(self.asViewFactoryForVinLookupView())
        )
    }

    func makeRecentSearchesView() -> AnyView {
        let vm = RecentSearchesViewModel(store: store)
        return AnyView(
            RecentSearchesView(viewModel: vm)
                .environmentObject(self.asViewFacotryForRecentSearchesView())
        )
    }
}
