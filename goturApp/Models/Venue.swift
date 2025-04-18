import Foundation

struct Venue: Identifiable {
    let id: String
    let name: String
    let category: RestaurantCategory
    let rating: Double
    let deliveryTime: String
    let minimumOrderAmount: Double
    let isPopular: Bool
}

struct Product: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let category: MenuCategory
}

enum RestaurantCategory: String, CaseIterable, Identifiable {
    case fastFood = "Fast Food"
    case italian = "İtalyan"
    case turkish = "Türk Mutfağı"
    case asian = "Asya Mutfağı"
    case dessert = "Tatlı & Pasta"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .fastFood:
            return "hamburger"
        case .italian:
            return "fork.knife"
        case .turkish:
            return "flame"
        case .asian:
            return "globe.asia.australia"
        case .dessert:
            return "birthday.cake"
        }
    }
}

enum MenuCategory: String, CaseIterable, Identifiable {
    case popular = "Popüler"
    case starters = "Başlangıçlar"
    case mainCourse = "Ana Yemekler"
    case sides = "Yan Lezzetler"
    case desserts = "Tatlılar"
    case drinks = "İçecekler"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .popular:
            return "star.fill"
        case .starters:
            return "circle.grid.2x1"
        case .mainCourse:
            return "fork.knife"
        case .sides:
            return "takeoutbag.and.cup.and.straw"
        case .desserts:
            return "birthday.cake"
        case .drinks:
            return "cup.and.saucer"
        }
    }
} 