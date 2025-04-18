import SwiftUI
import Foundation

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Restoranlar", systemImage: "fork.knife")
                }
            
            OrdersScreen()
                .tabItem {
                    Label("Siparişlerim", systemImage: "clock.fill")
                }
            
            CartView()
                .tabItem {
                    Label("Sepetim", systemImage: "cart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .accentColor(.vibrantOrange)
    }
}

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCategory: RestaurantCategory?
    @State private var venues: [Venue] = []
    @State private var isLoading = false
    @State private var userLocation = "İstanbul, Kadıköy"
    @State private var isLoadingLocation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.freshGreen.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    SearchBar(text: $searchText, placeholder: "Restoran ara")
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    // Konum Alanı
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.vibrantOrange)
                        
                        Text(userLocation)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button(action: {
                            getLocation()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.vibrantOrange)
                                .rotationEffect(.degrees(isLoadingLocation ? 360 : 0))
                                .animation(isLoadingLocation ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoadingLocation)
                        }
                        .disabled(isLoadingLocation)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    // Yakınındaki Restoranlar Başlığı
                    HStack {
                        Text("Yakınındaki Restoranlar")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(RestaurantCategory.allCases) { category in
                                CategoryButton(category: category, 
                                            isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding()
                    }
                    
                    if isLoading {
                        ProgressView("Yükleniyor...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if venues.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.vibrantOrange)
                            
                            Text("Restoran Bulunamadı")
                                .font(.title2)
                                .foregroundColor(.red)
                            
                            Text("Başka bir kategori seçin veya aramanızı değiştirin")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(filteredVenues) { venue in
                                    VenueCard(venue: venue)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("GÖTÜR")
                .onAppear {
                    loadVenues()
                }
            }
        }
    }
    
    var filteredVenues: [Venue] {
        if searchText.isEmpty && selectedCategory == nil {
            return venues
        }
        
        return venues.filter { venue in
            let matchesSearch = searchText.isEmpty || 
                venue.name.lowercased().contains(searchText.lowercased())
            
            let matchesCategory = selectedCategory == nil || 
                venue.category == selectedCategory
            
            return matchesSearch && matchesCategory
        }
    }
    
    func loadVenues() {
        isLoading = true
        // TODO: API'den restoranları yükle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.venues = createSampleVenues()
            self.isLoading = false
        }
    }
    
    func getLocation() {
        isLoadingLocation = true
        
        // Konum servisi simülasyonu
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Rastgele farklı konumlar gösterme
            let locations = [
                "İstanbul, Kadıköy",
                "İstanbul, Beşiktaş",
                "İstanbul, Şişli",
                "İstanbul, Ataşehir",
                "İstanbul, Beyoğlu"
            ]
            self.userLocation = locations.randomElement() ?? "İstanbul, Kadıköy"
            self.isLoadingLocation = false
            
            // Konuma göre restoranları yeniden yükleme
            self.loadVenues()
        }
    }
}

struct CategoryButton: View {
    let category: RestaurantCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: category.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : categoryColor)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? categoryColor : Color.white)
                    .cornerRadius(25)
                    .shadow(color: isSelected ? categoryColor.opacity(0.6) : Color.black.opacity(0.1), 
                            radius: 4, x: 0, y: 2)
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? categoryColor : .black)
            }
        }
    }
    
    var categoryColor: Color {
        switch category {
        case .fastFood:
            return .vibrantOrange
        case .italian:
            return .green
        case .turkish:
            return .red
        case .asian:
            return .purple
        case .dessert:
            return .pink
        }
    }
}

struct VenueCard: View {
    let venue: Venue
    
    var body: some View {
        NavigationLink(destination: VenueDetailView()) {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        categoryColor
                        Image(systemName: venue.category.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(height: 120)
                    .clipped()
                    
                    if venue.isPopular {
                        Text("Popüler")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(venue.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.black)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", venue.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Minimum: ₺\(venue.minimumOrderAmount, specifier: "%.0f")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(venue.deliveryTime) dk")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(8)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    var categoryColor: Color {
        switch venue.category {
        case .fastFood:
            return .vibrantOrange
        case .italian:
            return .green
        case .turkish:
            return .red
        case .asian:
            return .purple
        case .dessert:
            return .pink
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}

// Test verileri
func createSampleVenues() -> [Venue] {
    return [
        Venue(id: "v1", name: "Burger King", category: .fastFood, rating: 4.2, deliveryTime: "25-35", minimumOrderAmount: 50, isPopular: true),
        Venue(id: "v2", name: "McDonald's", category: .fastFood, rating: 4.3, deliveryTime: "20-30", minimumOrderAmount: 40, isPopular: false),
        Venue(id: "v3", name: "Domino's Pizza", category: .fastFood, rating: 4.0, deliveryTime: "30-40", minimumOrderAmount: 70, isPopular: true),
        Venue(id: "v4", name: "Mamma Mia", category: .italian, rating: 4.6, deliveryTime: "35-50", minimumOrderAmount: 100, isPopular: false),
        Venue(id: "v5", name: "Köfteci Yusuf", category: .turkish, rating: 4.8, deliveryTime: "25-40", minimumOrderAmount: 80, isPopular: true),
        Venue(id: "v6", name: "Sushico", category: .asian, rating: 4.7, deliveryTime: "40-60", minimumOrderAmount: 120, isPopular: false),
        Venue(id: "v7", name: "Pasta Citti", category: .dessert, rating: 4.4, deliveryTime: "20-30", minimumOrderAmount: 60, isPopular: true),
        Venue(id: "v8", name: "Çiya Sofrası", category: .turkish, rating: 4.9, deliveryTime: "30-45", minimumOrderAmount: 90, isPopular: false)
    ]
} 