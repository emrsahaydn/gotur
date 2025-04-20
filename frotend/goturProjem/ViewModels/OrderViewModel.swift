import SwiftUI
import Combine

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cart = Cart()
    
    // Sipariş geçmişini getir (mock veri)
    func fetchOrderHistory(userId: String) {
        isLoading = true
        errorMessage = nil
        
        // Gerçek uygulamada bu veri sunucudan gelecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // Örnek veri kullanıyoruz
            self.orders = Order.sampleOrders
            self.isLoading = false
        }
    }
    
    // Sipariş detayı getir
    func getOrderDetails(orderId: String) -> Order? {
        return orders.first { $0.id == orderId }
    }
    
    // Yeni sipariş oluştur
    func createOrder(userId: String, deliveryAddress: String) -> Bool {
        guard !cart.isEmpty, 
              let storeId = cart.storeId,
              let storeName = cart.storeName else {
            errorMessage = "Sepetiniz boş"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        // Sipariş nesnesi oluştur
        let orderItems = cart.items.map { cartItem in
            OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                quantity: cartItem.quantity,
                price: cartItem.product.price
            )
        }
        
        let newOrder = Order(
            id: UUID().uuidString,
            userId: userId,
            storeId: storeId,
            storeName: storeName,
            items: orderItems,
            total: cart.discountedTotal,
            status: .pending,
            deliveryNote: cart.deliveryNote.isEmpty ? nil : cart.deliveryNote,
            deliveryAddress: deliveryAddress,
            orderDate: Date(),
            promoCode: cart.promoCode,
            promoDiscount: cart.promoDiscount
        )
        
        // Gerçek uygulamada bu sipariş sunucuya gönderilecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Başarılı sipariş simülasyonu
            self.orders.insert(newOrder, at: 0)
            self.cart.clearCart()
            self.isLoading = false
        }
        
        return true
    }
    
    // Sipariş durumunu güncelle
    func updateOrderStatus(orderId: String, status: OrderStatus) {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if let index = self.orders.firstIndex(where: { $0.id == orderId }) {
                self.orders[index].status = status
            }
            
            self.isLoading = false
        }
    }
    
    // Promosyon kodunu uygula
    func applyPromoCode(_ code: String) -> Bool {
        return cart.applyPromoCode(code)
    }
    
    // Teslimat notu ekle
    func addDeliveryNote(_ note: String) {
        cart.deliveryNote = note
    }
} 