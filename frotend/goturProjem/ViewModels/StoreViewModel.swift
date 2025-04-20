import SwiftUI
import Combine

class StoreViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var searchQuery = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStore: Store?
    @Published var selectedCategory: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Filtreleme işlemi için searchQuery'i dinle
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterStores()
            }
            .store(in: &cancellables)
            
        // İlk verileri yükle
        fetchStores()
    }
    
    // Mağazaları getir (mock veri)
    func fetchStores() {
        isLoading = true
        errorMessage = nil
        
        // Gerçek uygulamada bu veri sunucudan gelecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // Örnek veri kullanıyoruz
            self.stores = Store.sampleStores
            self.isLoading = false
        }
    }
    
    // Mağaza detayı getir
    func fetchStoreDetails(storeId: String) {
        isLoading = true
        errorMessage = nil
        
        // Gerçek uygulamada bu veri sunucudan gelecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Mağazayı örneklerden bul
            if let store = Store.sampleStores.first(where: { $0.id == storeId }) {
                self.selectedStore = store
            } else {
                self.errorMessage = "Mağaza bulunamadı"
            }
            
            self.isLoading = false
        }
    }
    
    // Belirli bir kategorideki ürünleri getir
    func productsInCategory(_ category: String) -> [Product] {
        guard let store = selectedStore else { return [] }
        
        if category == "Tümü" {
            return store.products
        }
        
        return store.products.filter { $0.category == category }
    }
    
    // Tüm kategorileri al
    var categories: [String] {
        guard let store = selectedStore else { return [] }
        
        var categories = Set<String>()
        for product in store.products {
            categories.insert(product.category)
        }
        
        return ["Tümü"] + Array(categories).sorted()
    }
    
    // Arama sorgusu değiştiğinde mağazaları filtrele
    private func filterStores() {
        guard !searchQuery.isEmpty else {
            // Arama sorgusu boşsa tüm mağazaları göster
            fetchStores()
            return
        }
        
        let filteredStores = Store.sampleStores.filter { store in
            store.name.lowercased().contains(searchQuery.lowercased()) ||
            store.description.lowercased().contains(searchQuery.lowercased()) ||
            store.category.lowercased().contains(searchQuery.lowercased())
        }
        
        self.stores = filteredStores
    }
} 