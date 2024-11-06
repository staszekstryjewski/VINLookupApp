import SwiftUI

import VehicleLookup

struct VehicleDetailsView: View {
    
    let vehicle: Vehicle

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VehicleDetailsRow(
                        color: .red,
                        text: "WMI: \(vehicle.wmi)",
                        systemImage: "shield.fill")
                    VehicleDetailsRow(
                        color: .teal,
                        text: "VDS: \(vehicle.vds)",
                        systemImage: "doc.text.fill")
                    VehicleDetailsRow(
                        color: .indigo,
                        text: "VIS: \(vehicle.vis)",
                        systemImage: "doc.text.magnifyingglass")
                    VehicleDetailsRow(
                        color: .green,
                        text: "Country: \(vehicle.country)",
                        systemImage: "globe")
                    VehicleDetailsRow(
                        color: .yellow,
                        text: "Region: \(vehicle.region)",
                        systemImage: "map.fill")
                    VehicleDetailsRow(
                        color: .blue,
                        text: "Year: \(vehicle.year)",
                        systemImage: "calendar")

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(vehicle.vin)
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct VehicleDetailsRow: View {

    let color: Color
    let text: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(color)
            Text(text)
                .font(.body)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
