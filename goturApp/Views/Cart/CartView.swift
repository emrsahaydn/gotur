import SwiftUI

struct CartItemModel: Identifiable {
    let id: String
    let productName: String
    var quantity: Int
    let price: Double
}

struct CartView: View {
    @State private var cartItems: [CartItemModel] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "4FC3F7").opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                if cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 70))
                            .foregroundColor(Color(hex: "1E88E5"))
                        
                        Text("Sepetiniz Boş")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Henüz sepetinize ürün eklemediniz")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            // Ana sayfaya git
                        }) {
                            Text("Restoranlara Göz At")
                                .padding()
                                .foregroundColor(Color(hex: "1E88E5"))
                                .background(Color(hex: "1E88E5"))
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    VStack {
                        List {
                            ForEach(cartItems) { item in
                                CartItemRow(item: item)
                            }
                            .onDelete(perform: removeItems)
                            
                            Section(header: Text("Sipariş Özeti").font(.headline)) {
                                HStack {
                                    Text("Ara Toplam")
                                    Spacer()
                                    Text("₺\(String(format: "%.2f", calculateSubtotal()))")
                                }
                                
                                HStack {
                                    Text("Teslimat Ücreti")
                                    Spacer()
                                    Text("₺10.00")
                                }
                                
                                HStack {
                                    Text("Toplam")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("₺\(String(format: "%.2f", calculateTotal()))")
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        
                        Button(action: {
                            checkout()
                        }) {
                            Text("Siparişi Tamamla")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "1E88E5"))
                                .foregroundColor(Color(hex: "1E88E5"))
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Sepetim")
            .onAppear {
                loadCartItems()
            }
        }
    }
    
    private func loadCartItems() {
        // Örnek veriler
        cartItems = [
            CartItemModel(id: "1", productName: "Whopper Menü", quantity: 1, price: 85.0),
            CartItemModel(id: "2", productName: "Soğan Halkası", quantity: 2, price: 25.0)
        ]
    }
    
    private func removeItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
    
    private func calculateSubtotal() -> Double {
        cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    private func calculateTotal() -> Double {
        calculateSubtotal() + 10.0 // Teslimat ücretiyle birlikte
    }
    
    private func checkout() {
        // Sipariş tamamlama işlemi
        print("Sipariş tamamlanıyor...")
    }
}

struct CartItemRow: View {
    let item: CartItemModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.productName)
                    .font(.headline)
                
                Text("₺\(String(format: "%.2f", item.price))")
                    .foregroundColor(Color(hex: "1E88E5"))
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Azalt
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color(hex: "1E88E5"))
                }
                
                Text("\(item.quantity)")
                    .frame(width: 30, alignment: .center)
                
                Button(action: {
                    // Artır
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color(hex: "1E88E5"))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CartView()
} 
    
