import SwiftUI
import PhotosUI

import VehicleLookup

struct ImageToTextView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: ImageToTextViewModel

    @Binding var recognizedVIN: String

    var body: some View {
        VStack(spacing: 8) {
            ImageContainerView(image: viewModel.selectedImage)
            buttonsContainerView
            list
            Spacer()
        }
        .navigationTitle("Get VIN from Image")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: viewModel.onDisappear)
        .alert("Error",
               isPresented: Binding(value: $viewModel.errorMessage),
               actions: {}) {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .padding()
    }
}

private extension ImageToTextView {

    @ViewBuilder
    var list: some View {
        switch viewModel.stateInfo {
        case .initial:
            VStack(alignment: .leading, spacing: 16) {
                Text("Your results will be displayed here. Please select and process the image to get started.")
                Text("This is an experimental feature.")
                    .foregroundColor(.red)
            }
        case let .loading(message):
            ProgressView(message)
        case let .results(rows):
            Text("Results found:")
            List {
                ForEach(rows, id: \.text) { row in
                    HStack {
                        Text(row.text)
                        Spacer(minLength: 16)
                        Button {
                            recognizedVIN = row.text
                            dismiss()
                        } label: {
                            Text("Select")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .frame(maxHeight: 200)
        case .noResults:
            VStack(alignment: .leading, spacing: 16) {
                Text("No results found. Please select and process the image to get started.")
                Text("This is an experimental feature.")
                    .foregroundColor(.red)
                Text("If no text is detected, try different image or leave the screen to enter VIN manually.")
            }
        }
    }

    var buttonsContainerView: some View {
        HStack(spacing: 32) {
            PhotosPicker(
                selection: $viewModel.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select Image")
                    .font(.headline)
            }

            Button("Process Selected") {
                Task {
                    await viewModel.processImage()
                }
            }
            .disabled(viewModel.buttonsContainerViewDisabled)
        }
        .padding()
    }
}

private struct ImageContainerView: View {
    let image: UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 300)

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                VStack {
                    Image(systemName: "camera")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
        }
    }
}
