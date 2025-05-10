//
//  MainTabView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
            
            MarketplaceView()
                .tabItem {
                    Label("Marketplace", systemImage: "cart.fill")
                }
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            PlannerView()
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                }
            
            
            WardrobeView()
                .tabItem {
                    Label("Wardrobe", systemImage: "hanger")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


#Preview {
    MainTabView()
}
