//
//  ParetoArenaApp.swift
//  ParetoArena
//
//  Created by Zachary Coriarty on 9/13/23.
//

import SwiftUI

@main
struct ParetoArenaApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                // First tab: NewPortfolioView
                WatchlistView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)
                

                // Third tab: ExploreView
                ExploreVC()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(2)
                
                // Fifth tab: NewProfileView
                NewProfileVC()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(3)
            }
        }
    }
}
