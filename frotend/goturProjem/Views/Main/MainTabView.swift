import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Keşfet", systemImage: "house")
                }
                .tag(0)
            
            OrdersView()
                .tabItem {
                    Label("Siparişlerim", systemImage: "doc.text")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(StoreViewModel())
        .environmentObject(OrderViewModel())
} 