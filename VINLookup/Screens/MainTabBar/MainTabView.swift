import SwiftUI

struct MainTabView: View {

    @ObservedObject var model: AppModel

    var body: some View {
        TabView {
            model.viewsFactory.makeVinLookupView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("VIN Lookup")
                }

            model.viewsFactory.makeRecentSearchesView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Recent Searches")
                }
        }
    }
}
