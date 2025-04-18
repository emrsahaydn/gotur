import Foundation

struct UserModel: Codable, Identifiable {
    let id: String
    var name: String
    var email: String
    var phoneNumber: String?
    var address: [AddressModel]?
    var orderHistory: [OrderDataModel]?
}

struct AddressModel: Codable, Identifiable {
    let id: String
    var title: String
    var fullAddress: String
    var latitude: Double
    var longitude: Double
}

struct OrderDataModel: Codable, Identifiable {
    let id: String
    let date: Date
    let items: [OrderItemData]
    let totalAmount: Double
    let status: OrderDataStatus
    var deliveryNote: String?
    var promoCode: String?
}

struct OrderItemData: Codable, Identifiable {
    let id: String
    let productId: String
    let name: String
    let quantity: Int
    let price: Double
}

enum OrderDataStatus: String, Codable {
    case pending = "Beklemede"
    case preparing = "Hazırlanıyor"
    case onTheWay = "Yolda"
    case delivered = "Teslim Edildi"
    case cancelled = "İptal Edildi"
} 