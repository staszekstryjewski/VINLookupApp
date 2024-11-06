import SwiftUICore

protocol MainTabViewsFactory {
    func makeVinLookupView() -> AnyView
    func makeRecentSearchesView() -> AnyView
}

extension ViewsFactory: MainTabViewsFactory {}
