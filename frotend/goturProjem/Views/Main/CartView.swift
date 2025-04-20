import SwiftUI

struct CartView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var promoCode = ""
    @State private var isCheckingOut = false
    @State private var showOrderSuccess = false
    @State private var showNoteSheet = false
    @State private var animateOrderButton = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if orderViewModel.cart.isEmpty {
                    // Boş sepet
                    EmptyCartView()
                } else {
                    // Dolu sepet
                    VStack(spacing: 0) {
                        // Mağaza bilgisi
                        if let storeName = orderViewModel.cart.storeName {
                            HStack {
                                Image(systemName: "bag.fill")
                                    .font(.headline)
                                    .foregroundColor(Color.brandColor)
                                
                                Text(storeName)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.backgroundColor)
                        }
                        
                        // Ürün listesi
                        List {
                            Section {
                                ForEach(orderViewModel.cart.items) { item in
                                    CartItemRow(
                                        item: item,
                                        onIncrease: {
                                            withAnimation {
                                                orderViewModel.cart.updateQuantity(
                                                    productId: item.product.id,
                                                    quantity: item.quantity + 1
                                                )
                                            }
                                        },
                                        onDecrease: {
                                            withAnimation {
                                                orderViewModel.cart.updateQuantity(
                                                    productId: item.product.id,
                                                    quantity: item.quantity - 1
                                                )
                                            }
                                        },
                                        onRemove: {
                                            withAnimation {
                                                orderViewModel.cart.removeFromCart(productId: item.product.id)
                                            }
                                        }
                                    )
                                }
                            } header: {
                                Text("Ürünler")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            
                            // Teslimat notu
                            Section {
                                Button(action: {
                                    showNoteSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(Color.brandColor)
                                        
                                        Text(orderViewModel.cart.deliveryNote.isEmpty ? "Teslimat Notu Ekle" : "Teslimat Notu")
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        if !orderViewModel.cart.deliveryNote.isEmpty {
                                            Text(orderViewModel.cart.deliveryNote)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            } header: {
                                Text("Teslimat")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            
                            // Promosyon kodu
                            Section {
                                VStack(spacing: 12) {
                                    HStack {
                                        TextField("Promosyon Kodu", text: $promoCode)
                                            .padding(8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                            .autocapitalization(.allCharacters)
                                        
                                        Button("Uygula") {
                                            withAnimation {
                                                if orderViewModel.applyPromoCode(promoCode) {
                                                    promoCode = ""
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.brandColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                    
                                    if let code = orderViewModel.cart.promoCode {
                                        HStack {
                                            Label {
                                                Text("Promosyon Kodu: \(code)")
                                                    .font(.caption)
                                                    .foregroundColor(.green)
                                            } icon: {
                                                Image(systemName: "tag.fill")
                                                    .foregroundColor(.green)
                                                    .font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                withAnimation {
                                                    orderViewModel.cart.removePromoCode()
                                                }
                                            }) {
                                                Text("Kaldır")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                            } header: {
                                Text("Promosyon Kodu")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            
                            // Fiyat bilgileri
                            Section {
                                HStack {
                                    Text("Ara Toplam")
                                    Spacer()
                                    Text(String(format: "%.2f TL", orderViewModel.cart.totalPrice))
                                }
                                
                                if let discount = orderViewModel.cart.promoDiscount {
                                    HStack {
                                        Text("Promosyon İndirimi")
                                        Spacer()
                                        Text(String(format: "-%.2f TL", discount))
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                HStack {
                                    Text("Toplam")
                                        .font(.system(size: 16, weight: .bold))
                                    Spacer()
                                    Text(String(format: "%.2f TL", orderViewModel.cart.discountedTotal))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color.brandColor)
                                }
                            } header: {
                                Text("Toplam")
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        
                        // Sipariş ver butonu
                        CustomButton(
                            title: "Sipariş Ver",
                            icon: "bag.fill",
                            isDisabled: false,
                            action: placeOrder
                        )
                        .padding()
                        .scaleEffect(animateOrderButton ? 1.05 : 1.0)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                animateOrderButton = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sepetim")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
                
                if !orderViewModel.cart.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Temizle") {
                            withAnimation {
                                orderViewModel.cart.clearCart()
                            }
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Siparişiniz Alındı", isPresented: $showOrderSuccess) {
                Button("Tamam") {
                    dismiss()
                }
            } message: {
                Text("Siparişiniz başarıyla oluşturuldu. Sipariş durumunu 'Siparişlerim' ekranından takip edebilirsiniz.")
            }
            .sheet(isPresented: $showNoteSheet) {
                DeliveryNoteView(
                    note: orderViewModel.cart.deliveryNote,
                    onSave: { note in
                        orderViewModel.addDeliveryNote(note)
                        showNoteSheet = false
                    }
                )
            }
        }
    }
    
    private func placeOrder() {
        guard let user = authViewModel.currentUser else { return }
        
        isCheckingOut = true
        
        // Sipariş oluştur
        if orderViewModel.createOrder(userId: user.id, deliveryAddress: user.address) {
            isCheckingOut = false
            showOrderSuccess = true
        } else {
            isCheckingOut = false
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.7))
                .padding()
                .background(Circle().fill(Color.gray.opacity(0.1)))
            
            Text("Sepetiniz Boş")
                .font(.system(size: 22, weight: .semibold))
            
            Text("Alışverişe başlamak için mağazaları keşfedin ve ürünleri sepete ekleyin.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Ürün resmi
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            // Ürün bilgileri
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 15, weight: .medium))
                
                Text(String(format: "%.2f TL", item.product.price))
                    .font(.system(size: 14))
                    .foregroundColor(Color.brandColor)
            }
            
            Spacer()
            
            // Miktar kontrolleri
            HStack(spacing: 8) {
                Button(action: onDecrease) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 16, weight: .medium))
                    .frame(minWidth: 24)
                
                Button(action: onIncrease) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color.brandColor)
                }
            }
        }
        .contentShape(Rectangle())
        .swipeActions {
            Button(role: .destructive, action: onRemove) {
                Label("Sil", systemImage: "trash")
            }
        }
    }
}

struct DeliveryNoteView: View {
    @State var note: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $note)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Teslimat Notu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        onSave(note)
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.brandColor)
                }
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(OrderViewModel())
        .environmentObject(AuthViewModel())
} 