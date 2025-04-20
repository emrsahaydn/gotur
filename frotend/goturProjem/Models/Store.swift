import Foundation

struct Store: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var category: String
    var imageURL: String
    var address: String
    var deliveryTime: String
    var rating: Double
    var products: [Product]
    
    static var sampleStores: [Store] = [
        Store(id: "1", 
              name: "Hızlı Market", 
              description: "Günlük ihtiyaçlarınız için süper hızlı market", 
              category: "Market", 
              imageURL: "market", 
              address: "İstanbul, Kadıköy", 
              deliveryTime: "15-20 dk", 
              rating: 4.7,
              products: Product.sampleProducts),
        
        Store(id: "2", 
              name: "Sıcak Fırın", 
              description: "Taze fırın ürünleri", 
              category: "Fırın", 
              imageURL: "bakery", 
              address: "İstanbul, Beşiktaş", 
              deliveryTime: "20-30 dk", 
              rating: 4.5,
              products: Product.sampleProducts),
        
        Store(id: "3", 
              name: "Organik Şarküteri", 
              description: "En kaliteli şarküteri ürünleri", 
              category: "Şarküteri", 
              imageURL: "deli", 
              address: "İstanbul, Şişli", 
              deliveryTime: "25-35 dk", 
              rating: 4.8,
              products: Product.sampleProducts)
    ]
} 