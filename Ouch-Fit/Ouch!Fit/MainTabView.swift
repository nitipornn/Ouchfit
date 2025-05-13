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
                        .font(.custom("Classyvogueregular", size: 10))
                        .background(.black)
                }
            
            MarketplaceView()
                .tabItem {
                    Label("Marketplace", systemImage: "cart.fill")
                        .font(.custom("Classyvogueregular", size: 14))
                        .background(.black)
                }
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .font(.custom("Classyvogueregular", size: 14))
                        .background(.black)
                }

            PlannerView(wardrobeViewModel: WardrobeViewModel())
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                        .font(.custom("Classyvogueregular", size: 14))
                        .background(.black)
                }
            
            
            WardrobeView()
                .tabItem {
                    Label("Wardrobe", systemImage: "hanger")
                        .font(.custom("Classyvogueregular", size: 14))
                        .background(.black)
                }
        }
        .accentColor(.black)
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
