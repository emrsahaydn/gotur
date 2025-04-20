import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderViewModel: OrderViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showOrderDetail = false
    @State private var selectedOrder: Order?
    
    var body: some View {
        NavigationStack {
            VStack {
                if orderViewModel.isLoading {
                    LoadingView()
                } else if orderViewModel.orders.isEmpty {
                    // Sipariş yok
                    EmptyOrdersView()
                } else {
                    // Sipariş listesi
                    List {
                        ForEach(orderViewModel.orders) { order in
                            OrderRow(order: order)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedOrder = order
                                    showOrderDetail = true
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Siparişlerim")
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    orderViewModel.fetchOrderHistory(userId: userId)
                }
            }
            .sheet(isPresented: $showOrderDetail) {
                if let order = selectedOrder {
                    OrderDetailView(order: order)
                }
            }
        }
    }
}

struct EmptyOrdersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "doc.text")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("Sipariş Geçmişiniz Boş")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Henüz bir sipariş vermediniz. Alışverişe başlamak için mağazaları keşfedin.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct OrderRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Mağaza ve tarih
            HStack {
                Text(order.storeName)
                    .font(.headline)
                
                Spacer()
                
                Text(formatDate(order.orderDate))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Ürünler
            HStack {
                Text("\(order.items.count) Ürün")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(String(format: "%.2f TL", order.total))
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            
            // Durum
            HStack {
                Label(
                    order.status.rawValue,
                    systemImage: order.status.systemImage
                )
                .font(.footnote)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor(order.status).opacity(0.1))
                .foregroundColor(statusColor(order.status))
                .cornerRadius(4)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    // Sipariş tarihi formatla
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Durum rengini belirle
    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .onTheWay: return .blue
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}

struct OrderDetailView: View {
    let order: Order
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Mağaza bilgisi
                Section {
                    HStack {
                        Text("Mağaza")
                        Spacer()
                        Text(order.storeName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Durum")
                        Spacer()
                        Label(
                            order.status.rawValue,
                            systemImage: order.status.systemImage
                        )
                        .font(.subheadline)
                        .foregroundColor(statusColor(order.status))
                    }
                    
                    HStack {
                        Text("Tarih")
                        Spacer()
                        Text(formatDate(order.orderDate))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Teslimat Adresi")
                        Spacer()
                        Text(order.deliveryAddress)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if let note = order.deliveryNote {
                        HStack {
                            Text("Teslimat Notu")
                            Spacer()
                            Text(note)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                // Ürünler
                Section {
                    ForEach(order.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.productName)
                                
                                Text("\(item.quantity) x \(String(format: "%.2f TL", item.price))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.2f TL", item.total))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }
                } header: {
                    Text("Ürünler")
                }
                
                // Ödeme bilgileri
                Section {
                    HStack {
                        Text("Ürünler Toplamı")
                        Spacer()
                        Text(String(format: "%.2f TL", order.total))
                    }
                    
                    if let discount = order.promoDiscount {
                        HStack {
                            Text("Promosyon İndirimi")
                            if let code = order.promoCode {
                                Text("(\(code))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(String(format: "-%.2f TL", discount))
                                .foregroundColor(.green)
                        }
                    }
                    
                    HStack {
                        Text("Toplam")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f TL", order.total - (order.promoDiscount ?? 0)))
                            .fontWeight(.bold)
                    }
                } header: {
                    Text("Ödeme Detayları")
                }
            }
            .navigationTitle("Sipariş #\(order.id.prefix(8))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Sipariş tarihi formatla
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Durum rengini belirle
    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .onTheWay: return .blue
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}

#Preview {
    OrdersView()
        .environmentObject(OrderViewModel())
        .environmentObject(AuthViewModel())
} 