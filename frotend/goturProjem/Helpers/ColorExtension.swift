import SwiftUI

extension Color {
    static let brandColor = Color("BrandColor")
    static let secondaryColor = Color("SecondaryColor")
    static let backgroundColor = Color("BackgroundColor")
    static let textColor = Color("TextColor")
    
    // Renk varyasyonları
    static func brandColor(opacity: Double) -> Color {
        return brandColor.opacity(opacity)
    }
    
    static func secondaryColor(opacity: Double) -> Color {
        return secondaryColor.opacity(opacity)
    }
    
    // Sistem renk varyasyonları
    static let systemGray1 = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // Tema renk yardımcıları
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let info = Color.blue
}

extension View {
    func cardStyle() -> some View {
        self
            .padding(AppConstants.Layout.spacingXLarge)
            .background(Color.white)
            .cornerRadius(AppConstants.Layout.cornerRadiusLarge)
            .shadow(color: Color.black.opacity(0.05), 
                   radius: AppConstants.Layout.shadowRadiusMedium,
                   x: 0, y: 2)
    }
    
    func buttonStyle(isDisabled: Bool = false) -> some View {
        self
            .padding()
            .background(isDisabled ? Color.systemGray3 : Color.brandColor)
            .foregroundColor(.white)
            .cornerRadius(AppConstants.Layout.cornerRadiusMedium)
            .shadow(color: Color.brandColor.opacity(0.3), 
                   radius: AppConstants.Layout.shadowRadiusSmall,
                   x: 0, y: 2)
    }
    
    func textFieldStyle() -> some View {
        self
            .padding()
            .background(Color.systemGray6)
            .cornerRadius(AppConstants.Layout.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
    
    func errorViewStyle() -> some View {
        self
            .padding(.vertical, AppConstants.Layout.spacingLarge)
            .padding(.horizontal, AppConstants.Layout.spacingXLarge)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                    .fill(Color.error.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                    .stroke(Color.error.opacity(0.2), lineWidth: 1)
            )
    }
    
    func successViewStyle() -> some View {
        self
            .padding(.vertical, AppConstants.Layout.spacingLarge)
            .padding(.horizontal, AppConstants.Layout.spacingXLarge)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                    .fill(Color.success.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                    .stroke(Color.success.opacity(0.2), lineWidth: 1)
            )
    }
    
    func standardAnimation() -> some View {
        self.animation(AppConstants.Animation.standard, value: UUID())
    }
} 