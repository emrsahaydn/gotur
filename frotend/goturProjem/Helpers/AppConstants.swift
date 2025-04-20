import Foundation
import SwiftUI

struct AppConstants {
    
    struct Layout {
        // Genişlik-Yükseklik Değerleri
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        
        // Köşe Yuvarlatma
        static let cornerRadiusSmall: CGFloat = 8
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusLarge: CGFloat = 16
        
        // Padding/Margin
        static let paddingSmall: CGFloat = 8
        static let paddingMedium: CGFloat = 16
        static let paddingLarge: CGFloat = 24
        
        // Aralıklar
        static let spacingSmall: CGFloat = 8
        static let spacingMedium: CGFloat = 12
        static let spacingLarge: CGFloat = 20
        static let spacingXLarge: CGFloat = 24
        
        // Gölgeler
        static let shadowRadiusSmall: CGFloat = 4
        static let shadowRadiusMedium: CGFloat = 8
        static let shadowRadiusLarge: CGFloat = 12
        
        // Bileşen Boyutları
        static let buttonHeight: CGFloat = 50
        static let textFieldHeight: CGFloat = 56
        static let iconSize: CGFloat = 24
        static let avatarSizeSmall: CGFloat = 40
        static let avatarSizeMedium: CGFloat = 60
        static let avatarSizeLarge: CGFloat = 100
        
        // Animasyon Süresi
        static let animationDurationShort: Double = 0.2
        static let animationDurationMedium: Double = 0.3
        static let animationDurationLong: Double = 0.5
    }
    
    struct FontSize {
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 14
        static let medium: CGFloat = 16
        static let large: CGFloat = 18
        static let xLarge: CGFloat = 20
        static let xxLarge: CGFloat = 24
        static let xxxLarge: CGFloat = 32
    }
    
    struct API {
        static let baseUrl = "https://api.gotursepeti.com"
        static let timeoutInterval: TimeInterval = 30
        
        enum Endpoints {
            static let login = "/auth/login"
            static let register = "/auth/register"
            static let products = "/products"
            static let categories = "/categories"
            static let cart = "/cart"
            static let orders = "/orders"
            static let profile = "/user/profile"
        }
    }
    
    struct Animation {
        static let `default` = SwiftUI.Animation.easeInOut(duration: Layout.animationDurationMedium)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.6)
        static let bounce = SwiftUI.Animation.interpolatingSpring(mass: 1.0, stiffness: 100, damping: 10)
    }
    
    struct Storage {
        static let userTokenKey = "userToken"
        static let userDataKey = "userData"
        static let cartItemsKey = "cartItems"
        static let favoriteItemsKey = "favoriteItems"
        static let themeKey = "appTheme"
        static let languageKey = "appLanguage"
    }
} 