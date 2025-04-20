import Foundation

class Cart: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var storeId: String?
    @Published var storeName: String?
    @Published var promoCode: String?
    @Published var promoDiscount: Double?
    @Published var deliveryNote: String = ""
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var discountedTotal: Double {
        let total = totalPrice
        if let discount = promoDiscount {
            return max(0, total - discount)
        }
        return total
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    func addToCart(product: Product, storeId: String, storeName: String) {
        // Eğer farklı bir mağazadan ürün ekleniyorsa, sepeti temizle
        if let currentStoreId = self.storeId, currentStoreId != storeId {
            clearCart()
        }
        
        self.storeId = storeId
        self.storeName = storeName
        
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(productId: String) {
        items.removeAll { $0.product.id == productId }
        
        if items.isEmpty {
            clearCart()
        }
    }
    
    func updateQuantity(productId: String, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
        
        if items.isEmpty {
            clearCart()
        }
    }
    
    func clearCart() {
        items = []
        storeId = nil
        storeName = nil
        promoCode = nil
        promoDiscount = nil
        deliveryNote = ""
    }
    
    func applyPromoCode(_ code: String) -> Bool {
        // Basit promo kod uygulama mantığı
        // Gerçek bir uygulamada bu işlem sunucu tarafında yapılır
        if code == "HOSGELDIN10" {
            promoCode = code
            promoDiscount = 10.0
            return true
        } else if code == "YENI20" && totalPrice > 50 {
            promoCode = code
            promoDiscount = 20.0
            return true
        }
        return false
    }
    
    func removePromoCode() {
        promoCode = nil
        promoDiscount = nil
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
} 