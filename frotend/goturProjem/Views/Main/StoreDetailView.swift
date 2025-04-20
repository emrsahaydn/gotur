import SwiftUI

struct StoreDetailView: View {
    let storeId: String
    @EnvironmentObject var storeViewModel: StoreViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel
    @State private var selectedCategory = "Tümü"
    @State private var showCart = false
    @State private var showAddedAnimation = false
    @State private var lastAddedProduct: Product?
    
    var body: some View {
        VStack(spacing: 0) {
            if storeViewModel.isLoading {
                LoadingView()
            } else if let store = storeViewModel.selectedStore {
                // Mağaza başlık
                StoreHeader(store: store)
                
                // Kategori seçimi
                CategoryPicker(
                    selectedCategory: $selectedCategory,
                    categories: storeViewModel.categories
                )
                
                // Ürün listesi
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(storeViewModel.productsInCategory(selectedCategory)) { product in
                            ProductCard(product: product) {
                                orderViewModel.cart.addToCart(
                                    product: product,
                                    storeId: store.id,
                                    storeName: store.name
                                )
                                
                                // Animasyon için son eklenen ürünü kaydet
                                withAnimation {
                                    lastAddedProduct = product
                                    showAddedAnimation = true
                                }
                                
                                // Animasyonu kapat
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showAddedAnimation = false
                                    }
                                }
                            }
                            .overlay(
                                Group {
                                    if showAddedAnimation && lastAddedProduct?.id == product.id {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                            Text("Sepete Eklendi")
                                        }
                                        .font(.footnote)
                                        .padding(6)
                                        .background(Color.green.opacity(0.9))
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                        .transition(.scale.combined(with: .opacity))
                                        .padding(8)
                                    }
                                }
                                , alignment: .bottomTrailing
                            )
                        }
                    }
                    .padding()
                }
                
                // Sepet butonu
                if !orderViewModel.cart.isEmpty {
                    CartButton(cart: orderViewModel.cart) {
                        showCart = true
                    }
                }
            } else {
                EmptyResultView(message: "Mağaza bulunamadı")
            }
        }
        .navigationTitle(storeViewModel.selectedStore?.name ?? "Mağaza Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            storeViewModel.fetchStoreDetails(storeId: storeId)
        }
        .sheet(isPresented: $showCart) {
            CartView()
        }
    }
}

struct StoreHeader: View {
    let store: Store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Mağaza resmi
            ZStack(alignment: .bottomLeading) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                            startPoint: .leading, 
                            endPoint: .trailing
                        )
                    )
                
                // Mağaza bilgisi gradyan ile
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(store.category)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
            
            // Mağaza bilgileri
            VStack(alignment: .leading, spacing: 12) {
                Text(store.description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                
                HStack {
                    Label {
                        Text(store.deliveryTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    } icon: {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color.brandColor)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Label {
                        Text(String(format: "%.1f", store.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

struct CategoryPicker: View {
    @Binding var selectedCategory: String
    var categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category,
                        action: {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color.backgroundColor)
    }
}

struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.brandColor.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? Color.brandColor : .gray)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.brandColor.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        }
    }
}

struct ProductCard: View {
    let product: Product
    let addAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Ürün resmi
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            // Ürün bilgileri
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.system(size: 16, weight: .medium))
                
                Text(product.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(String(format: "%.2f TL", product.price))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.brandColor)
                    .padding(.top, 2)
            }
            
            Spacer()
            
            // Sepete ekle butonu
            Button(action: addAction) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.brandColor)
                    .shadow(color: Color.brandColor.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CartButton: View {
    let cart: Cart
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("\(cart.itemCount) Ürün")
                        .font(.system(size: 15, weight: .semibold))
                }
                
                Spacer()
                
                Text(String(format: "%.2f TL", cart.totalPrice))
                    .font(.system(size: 15, weight: .semibold))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .padding(.leading, 4)
            }
            .padding()
            .background(Color.brandColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.brandColor.opacity(0.5), radius: 8, x: 0, y: 4)
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        StoreDetailView(storeId: "1")
            .environmentObject(StoreViewModel())
            .environmentObject(OrderViewModel())
    }
} 