import SwiftUI

struct RecentSearchesView: View {

    @EnvironmentObject var factory: ViewFacotryForRecentSearchesView
    @ObservedObject var viewModel: RecentSearchesViewModel

    var body: some View {
        NavigationStack {
            if viewModel.recentSearches.isEmpty {
                ContentUnavailableView {
                    Label("No Recent Searches", systemImage: "car.side.roof.cargo.carrier.slash")
                        .symbolRenderingMode(.multicolor)
                } description: {
                    Text("Recent searches will appear here.")
                }
            }

            List(viewModel.recentSearches) { entry in
                RecentSearchRow(entry: entry)
                    .onTapGesture {
                        viewModel.selectedVehicle = entry.vehicle
                    }
            }
            .navigationTitle("Recent searches")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.loadData()
            }
        }
        .task {
            await viewModel.loadData()
        }
        .sheet(item: $viewModel.selectedVehicle) { vehicle in
            factory.makeVehicleDetailsView(vehicle: vehicle)
        }
        .alert("Error",
               isPresented: Binding(value: $viewModel.errorMessage),
               actions: {}) {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}

private struct RecentSearchRow: View {
    let entry: RecentSearch

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "car")
                .font(.largeTitle)
                .foregroundStyle(.gray)
            VStack(alignment: .leading) {
                Text(entry.vehicle.vin)
                    .font(.headline)
                Text(entry.date, format: .dateTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
