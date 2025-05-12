import SwiftUI
import Firebase
import FirebaseDatabase

@main
struct Ouch_FitApp: App {
    @State private var isLoggedIn = false
    @StateObject private var viewModel = WardrobeViewModel()
    
    init() {
        // Ensure Firebase is configured when the app starts
        FirebaseApp.configure()
        // Set the correct database URL as per the region
        Database.database(url: "https://ouch-fit-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }

    var body: some Scene {
        WindowGroup {
            
            if isLoggedIn {
                // If the user is logged in, show the HomeView
                MainTabView()
            } else {
                // If not logged in, show the LoginView
                LoginView(isLoggedIn: $isLoggedIn)
            }
            WardrobePage(viewModel: viewModel)
        }
    }
    
    
}
