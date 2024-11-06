import PhotosUI
import SwiftUI

import VehicleLookup

final class ImageToTextViewModel: ObservableObject {

    enum StateInfo {
        case initial
        case loading(message: String)
        case noResults
        case results(rows: [ImageToText])
    }

    @Published var stateInfo: StateInfo = .initial
    @Published var selectedImage: UIImage?
    @Published var errorMessage: String?

    @MainActor
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            stateInfo = .initial
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImageData = data
                    selectedImage = image
                }
            }
        }
    }

    var buttonsContainerViewDisabled: Bool {
        selectedImage == nil || isLoading
    }

    private var isLoading = false
    private var selectedImageData: Data?
    private let service: ImageToTextService
    private var runningTask: Task<Void, Never>?

    init(service: ImageToTextService) {
        self.service = service
    }

    @MainActor
    func processImage() async {
        guard let imageData = selectedImageData else { return }

        runningTask = Task {
            stateInfo = .loading(message: "Processing image..")
            isLoading = true
            defer { isLoading = false }
            do {
                try Task.checkCancellation()
                let results = try await service.imageToText(from: imageData)
                stateInfo = results.isEmpty ? .noResults : .results(rows: results)
            } catch is CancellationError {
                // do nothing
            } catch {
                errorMessage = "Something went wrong. Please try again later."
                stateInfo = .noResults
            }
        }
    }

    func onDisappear() {
        runningTask?.cancel()
    }
}
