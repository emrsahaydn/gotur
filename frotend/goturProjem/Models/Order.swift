import Foundation

struct Order: Codable, Identifiable {
    var id: String
    var userId: String
    var storeId: String
    var storeName: String
    var items: [OrderItem]
    var total: Double
    var status: OrderStatus
    var deliveryNote: String?
    var deliveryAddress: String
    var orderDate: Date
    var promoCode: String?
    var promoDiscount: Double?
    
    static var sample: Order {
        Order(
            id: UUID().uuidString,
            userId: "user123",
            storeId: "store123",
            storeName: "Hızlı Market",
            items: [
                OrderItem(productId: "1", productName: "Su (1L)", quantity: 2, price: 5.90),
                OrderItem(productId: "2", productName: "Ekmek", quantity: 1, price: 7.50)
            ],
            total: 19.30,
            status: .delivered,
            deliveryNote: "Kapıya bırakabilirsiniz",
            deliveryAddress: "İstanbul, Kadıköy",
            orderDate: Date().addingTimeInterval(-86400),
            promoCode: "HOSGELDIN10",
            promoDiscount: 5.0
        )
    }
    
    static var sampleOrders: [Order] = [
        Order(
            id: UUID().uuidString,
            userId: "user123",
            storeId: "store123",
            storeName: "Hızlı Market",
            items: [
                OrderItem(productId: "1", productName: "Su (1L)", quantity: 2, price: 5.90),
                OrderItem(productId: "2", productName: "Ekmek", quantity: 1, price: 7.50)
            ],
            total: 19.30,
            status: .delivered,
            deliveryNote: "Kapıya bırakabilirsiniz",
            deliveryAddress: "İstanbul, Kadıköy",
            orderDate: Date().addingTimeInterval(-86400),
            promoCode: nil,
            promoDiscount: nil
        ),
        Order(
            id: UUID().uuidString,
            userId: "user123",
            storeId: "store456",
            storeName: "Sıcak Fırın",
            items: [
                OrderItem(productId: "4", productName: "Yumurta (10'lu)", quantity: 1, price: 45.90),
                OrderItem(productId: "3", productName: "Süt (1L)", quantity: 2, price: 19.90)
            ],
            total: 85.70,
            status: .onTheWay,
            deliveryNote: nil,
            deliveryAddress: "İstanbul, Kadıköy",
            orderDate: Date(),
            promoCode: "YENI20",
            promoDiscount: 10.0
        )
    ]
}

struct OrderItem: Codable, Identifiable {
    var id: String { productId }
    var productId: String
    var productName: String
    var quantity: Int
    var price: Double
    
    var total: Double {
        Double(quantity) * price
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case pending = "Hazırlanıyor"
    case onTheWay = "Yolda"
    case delivered = "Teslim Edildi"
    case cancelled = "İptal Edildi"
    
    var systemImage: String {
        switch self {
        case .pending: return "clock"
        case .onTheWay: return "bicycle"
        case .delivered: return "checkmark.circle"
        case .cancelled: return "xmark.circle"
        }
    }
} 