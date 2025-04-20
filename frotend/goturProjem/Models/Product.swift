import Foundation

struct Product: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    var category: String
    
    static var sampleProducts: [Product] = [
        Product(id: "1", name: "Su (1L)", description: "Doğal içme suyu", price: 5.90, imageURL: "water_bottle", category: "İçecek"),
        Product(id: "2", name: "Ekmek", description: "Taze günlük ekmek", price: 7.50, imageURL: "bread", category: "Fırın"),
        Product(id: "3", name: "Süt (1L)", description: "Günlük taze süt", price: 19.90, imageURL: "milk", category: "Süt Ürünleri"),
        Product(id: "4", name: "Yumurta (10'lu)", description: "Organik yumurta", price: 45.90, imageURL: "eggs", category: "Kahvaltılık"),
        Product(id: "5", name: "Elma (1kg)", description: "Taze kırmızı elma", price: 24.90, imageURL: "apple", category: "Meyve")
    ]
} 