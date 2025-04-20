import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storeViewModel: StoreViewModel
    @State private var selectedStore: Store?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Arama çubuğu
                SearchBar(text: $storeViewModel.searchQuery)
                
                if storeViewModel.isLoading {
                    // Yükleniyor
                    LoadingView()
                } else if storeViewModel.stores.isEmpty {
                    // Sonuç bulunamadı
                    EmptyResultView(message: "Mağaza bulunamadı")
                } else {
                    // Mağaza listesi
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(storeViewModel.stores) { store in
                                NavigationLink(destination: StoreDetailView(storeId: store.id)) {
                                    StoreCard(store: store)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Götür")
            .onAppear {
                storeViewModel.fetchStores()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Mağaza veya ürün ara", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct StoreCard: View {
    let store: Store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Mağaza resmi
            ZStack(alignment: .bottomLeading) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(store.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(store.category)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(10)
            }
            
            // Mağaza bilgileri
            HStack {
                Label(store.deliveryTime, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Label(String(format: "%.1f", store.rating), systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(store.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            Text("Yükleniyor...")
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
    }
}

struct EmptyResultView: View {
    var message: String
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding()
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(StoreViewModel())
} 