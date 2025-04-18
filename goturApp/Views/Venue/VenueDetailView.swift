import SwiftUI
import Foundation

struct VenueDetailView: View {
    @State private var searchText = ""
    @State private var selectedCategory: MenuCategory?
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var showingCart = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                ZStack(alignment: .bottomLeading) {
                    // Placeholder görseli yerine renk ve icon kullanıyorum
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .red]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(height: 200)
                    .clipped()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    
                    Text("Burger King")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                
                // Venue Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("4.8", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Text("(250+)")
                            .foregroundColor(.gray)
                        Text("•")
                        Text("Fast Food")
                            .foregroundColor(.orange)
                        Text("•")
                        Text("25-35 dk")
                    }
                    .font(.subheadline)
                    
                    Text("Minimum Sipariş: ₺50")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding()
                
                // Search Bar
                SearchBar(text: $searchText, placeholder: "Menüde ara")
                    .padding(.horizontal)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(MenuCategory.allCases) { category in
                            ProductCategoryButton(category: category,
                                         isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                }
                
                if isLoading {
                    ProgressView("Yükleniyor...")
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    // Products
                    LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                        ForEach(MenuCategory.allCases) { category in
                            Section(header: ProductSectionHeader(title: category.rawValue, 
                                                              icon: category.iconName)) {
                                ForEach(getFilteredProducts(for: category)) { product in
                                    ProductRow(product: product, onAddToCart: { addToCart(product) })
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.blue.opacity(0.05))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingCart = true
                } label: {
                    Image(systemName: "cart")
                        .foregroundColor(.orange)
                }
            }
        }
        .sheet(isPresented: $showingCart) {
            NavigationView {
                CartView()
            }
        }
        .onAppear {
            loadProducts()
        }
    }
    
    func getFilteredProducts(for category: MenuCategory) -> [Product] {
        if searchText.isEmpty {
            return products.filter { $0.category == category }
        } else {
            return products.filter { 
                $0.category == category && 
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func loadProducts() {
        isLoading = true
        // TODO: API'den ürünleri yükle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.products = createSampleProducts()
            self.isLoading = false
        }
    }
    
    func addToCart(_ product: Product) {
        // TODO: Ürünü sepete ekle
        print("Added to cart: \(product.name)")
    }
}

struct ProductCategoryButton: View {
    let category: MenuCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.iconName)
                    .foregroundColor(isSelected ? .white : categoryColor)
                    .font(.system(size: 15))
                    .padding(6)
                
                Text(category.rawValue)
                    .foregroundColor(isSelected ? .white : categoryColor)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(isSelected ? categoryColor : categoryColor.opacity(0.15))
            .cornerRadius(20)
        }
    }
    
    var categoryColor: Color {
        switch category {
        case .popular:
            return .orange
        case .starters:
            return .blue
        case .mainCourse:
            return .red
        case .sides:
            return .mint
        case .desserts:
            return .pink
        case .drinks:
            return .green
        }
    }
}

struct ProductSectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.system(size: 18))
            
            Text(title)
                .font(.headline)
                .foregroundColor(.orange)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

struct ProductRow: View {
    let product: Product
    let onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                categoryColor.opacity(0.2)
                Image(systemName: product.category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(categoryColor)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text("₺\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .foregroundColor(categoryColor)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button(action: onAddToCart) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(categoryColor)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    var categoryColor: Color {
        switch product.category {
        case .popular:
            return .orange
        case .starters:
            return .blue
        case .mainCourse:
            return .red
        case .sides:
            return .mint
        case .desserts:
            return .pink
        case .drinks:
            return .green
        }
    }
}

// Test verileri
func createSampleProducts() -> [Product] {
    return [
        // Popüler
        Product(id: "p1", name: "Whopper Menü", description: "Whopper burger, patates kızartması ve içecek", price: 85.0, category: .popular),
        Product(id: "p2", name: "Big King Menü", description: "Big King burger, patates kızartması ve içecek", price: 89.0, category: .popular),
        Product(id: "p3", name: "Chicken Royale", description: "Tavuk burger, patates kızartması ve içecek", price: 75.0, category: .popular),
        
        // Başlangıçlar
        Product(id: "p4", name: "Soğan Halkası", description: "6 adet çıtır soğan halkası", price: 25.0, category: .starters),
        Product(id: "p5", name: "Çıtır Tavuk", description: "8 parça çıtır tavuk", price: 35.0, category: .starters),
        Product(id: "p6", name: "Nachos", description: "Peynir soslu nachos", price: 30.0, category: .starters),
        
        // Ana Yemekler
        Product(id: "p7", name: "Texas Smokehouse", description: "Barbekü soslu özel burger", price: 95.0, category: .mainCourse),
        Product(id: "p8", name: "Double Whopper", description: "İki katlı whopper burger", price: 105.0, category: .mainCourse),
        Product(id: "p9", name: "Steakhouse Burger", description: "Özel soslu burger", price: 100.0, category: .mainCourse),
        
        // Yan Lezzetler
        Product(id: "p10", name: "Patates Kızartması", description: "Orta boy patates kızartması", price: 20.0, category: .sides),
        Product(id: "p11", name: "Çıtır Peynir", description: "8 adet çıtır peynir", price: 28.0, category: .sides),
        
        // Tatlılar
        Product(id: "p12", name: "Sundae", description: "Çikolata soslu dondurma", price: 18.0, category: .desserts),
        Product(id: "p13", name: "Sufle", description: "Sıcak çikolatalı sufle", price: 25.0, category: .desserts),
        
        // İçecekler
        Product(id: "p14", name: "Kola", description: "Orta boy kola", price: 15.0, category: .drinks),
        Product(id: "p15", name: "Ayran", description: "Ayran", price: 10.0, category: .drinks),
        Product(id: "p16", name: "Milkshake", description: "Çikolatalı milkshake", price: 22.0, category: .drinks)
    ]
}

#Preview {
    NavigationView {
        VenueDetailView()
    }
} 