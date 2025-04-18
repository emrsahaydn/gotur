import SwiftUI

// Order ve OrderItem model sınıfları için
struct OrderViewModel: Identifiable {
    let id: String
    let restaurantName: String
    let date: Date
    let status: String
    let items: [OrderItemViewModel]
    let totalAmount: Double
}

struct OrderItemViewModel: Identifiable {
    var id = UUID()
    var productId: String = "default"
    let name: String
    let quantity: Int
    let price: Double
}

struct OrdersScreen: View {
    @State private var orders: [OrderViewModel] = []
    
    var body: some View {
        ZStack {
            Color(hex: "4FC3F7").opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            if orders.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "bag")
                        .font(.system(size: 70))
                        .foregroundColor(.orange)
                    
                    Text("Henüz Siparişiniz Yok")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Siparişleriniz burada görünecektir")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // Ana sayfaya git
                    }) {
                        Text("Restoranlara Göz At")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex: "1E88E5"))
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            } else {
                List {
                    ForEach(orders) { order in
                        OrderCardView(order: order)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Sipariş Geçmişim")
        .onAppear {
            loadOrders()
        }
    }
    
    private func loadOrders() {
        // Örnek veriler
        orders = [
            OrderViewModel(
                id: "1",
                restaurantName: "Burger King",
                date: Date().addingTimeInterval(-86400), // 1 gün önce
                status: "Teslim Edildi",
                items: [
                    OrderItemViewModel(id: UUID(), productId: "p1", name: "Whopper Menü", quantity: 1, price: 85.0),
                    OrderItemViewModel(id: UUID(), productId: "p2", name: "Soğan Halkası", quantity: 2, price: 25.0)
                ],
                totalAmount: 135.0
            ),
            OrderViewModel(
                id: "2",
                restaurantName: "Domino's Pizza",
                date: Date().addingTimeInterval(-259200), // 3 gün önce
                status: "Teslim Edildi",
                items: [
                    OrderItemViewModel(id: UUID(), productId: "p3", name: "Karışık Pizza (Büyük)", quantity: 1, price: 120.0),
                    OrderItemViewModel(id: UUID(), productId: "p4", name: "Coca-Cola 1L", quantity: 1, price: 15.0)
                ],
                totalAmount: 135.0
            )
        ]
    }
}

struct OrderCardView: View {
    let order: OrderViewModel
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(order.restaurantName)
                        .font(.headline)
                    
                    Text(formatDate(order.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(order.status)
                    .font(.caption)
                    .padding(6)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(5)
            }
            
            Divider()
            
            HStack {
                Text("Toplam: ₺\(String(format: "%.2f", order.totalAmount))")
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Gizle" : "Detaylar")
                        .font(.caption)
                        .foregroundColor(Color(hex: "1E88E5"))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sipariş Detayları")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    
                    ForEach(order.items) { item in
                        HStack {
                            Text("\(item.quantity)x")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(item.name)
                                .font(.caption)
                            
                            Spacer()
                            
                            Text("₺\(String(format: "%.2f", item.price * Double(item.quantity)))")
                                .font(.caption)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Siparişi tekrarla
                        }) {
                            Text("Siparişi Tekrarla")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "1E88E5"))
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding(.top, 5)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.vertical, 5)
    }
    
    private var statusColor: Color {
        switch order.status {
        case "Teslim Edildi":
            return .green
        case "Hazırlanıyor":
            return .orange
        case "Yolda":
            return .blue
        case "İptal Edildi":
            return .red
        default:
            return .gray
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        OrdersScreen()
    }
} 