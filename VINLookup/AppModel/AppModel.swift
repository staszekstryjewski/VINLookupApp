import Foundation

import VehicleLookup
import ValidatedInputComponent

final class AppModel: ObservableObject {

    let store: AnyStore<RecentSearch>
    let service: VehicleLookupService & ImageToTextService
    let vinLookupViewModel: VinLookupViewModel
    let viewsFactory: ViewsFactory
    let validator: AnyValidator<String>

    init(session: URLSession, apiToken: String, storeFileName: String) {
        store = RecentSearchesStore(filename: storeFileName).asAnyStore()
        
        validator = VehicleVINValidator().asAnyValidator()

        service = LookupService(
            session: session,
            apiToken: apiToken)

        vinLookupViewModel = VinLookupViewModel(
            vinService: service,
            store: store)

        viewsFactory = ViewsFactory(
            vinService: service,
            imageToTextService: service,
            validator: validator,
            store: store)
    }
}
