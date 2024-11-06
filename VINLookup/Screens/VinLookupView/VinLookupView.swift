import SwiftUI

import ValidatedInputComponent

struct VinLookupView: View {

    @EnvironmentObject var factory: ViewFactoryForVinLookupView
    @ObservedObject var viewModel: VinLookupViewModel

    private let validator: AnyValidator<String>

    @State private var showImagePicker: Bool = false
    @State private var validated: Bool = false

    init(viewModel: VinLookupViewModel, validator: AnyValidator<String>) {
        self.viewModel = viewModel
        self.validator = validator
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter VIN manually or try image to text recognition")

            HStack(alignment: .firstTextBaseline) {
                ValidatedInputField(
                    query: $viewModel.vinString,
                    validator: validator,
                    placeholder: "Enter VIN",
                    errorMessage: "Invalid VIN entered") {
                        validated = $0
                    }

                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "camera")
                }
            }

            searchButtonSwappingToProgressViewComponent
        }
        .padding()
        .sheet(item: $viewModel.vehicle) { vehicle in
            factory.makeVehicleDetailsView(vehicle: vehicle)
        }
        .sheet(isPresented: $showImagePicker) {
            factory.makeImageToTextView(binding: $viewModel.vinString)
        }
        .alert("Error",
               isPresented: Binding(value: $viewModel.errorMessage),
               actions: {},
               message: {
            Text(viewModel.errorMessage ?? "")
        })
    }

    @ViewBuilder
    private var searchButtonSwappingToProgressViewComponent: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        } else {
            Button {
                Task {
                    await viewModel.performSearch()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .disabled(!validated)
            .disabled(viewModel.isLoading)
        }
    }
}
