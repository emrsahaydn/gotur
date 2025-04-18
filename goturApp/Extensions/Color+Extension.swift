import SwiftUI

extension Color {
    static let primaryApp = Color("primaryApp")
    static let secondaryApp = Color("secondaryApp")
    
    // Ana renkler
    static let vibrantOrange = Color(hex: "1E88E5") // Canlı Mavi (Ana renk)
    static let vibrantRed = Color(hex: "0D47A1")    // Koyu Mavi (Vurgu rengi)
    static let freshGreen = Color(hex: "4FC3F7")    // Açık Mavi (tazelik ve ferahlık)
    static let skyBlue = Color(hex: "5AC8FA")       // Gökyüzü mavisi (ferahlık)
    static let sunnyYellow = Color(hex: "42A5F5")   // Parlak Mavi (canlılık)
    static let richPurple = Color(hex: "7986CB")    // Mor-Mavi (premium, lüks)
    static let coolMint = Color(hex: "26C6DA")      // Turkuaz (ferahlık)
    
    // Restoran kategorileri için renkler
    static let fastFoodColor = Color(hex: "1E88E5") // Canlı Mavi
    static let italianColor = Color(hex: "039BE5")  // Açık Mavi
    static let turkishColor = Color(hex: "0D47A1")  // Koyu Mavi
    static let asianColor = Color(hex: "26C6DA")    // Turkuaz Mavi
    static let dessertColor = Color(hex: "7986CB")  // Mor-Mavi
    
    // Yardımcı fonksiyon - Hex değerlerini renk olarak dönüştürmek için
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 