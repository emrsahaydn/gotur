import SwiftUI

struct CustomButton: View {
    
    // MARK: - Properties
    var title: String
    var icon: String?
    var isDisabled: Bool
    var action: () -> Void
    var style: ButtonStyle = .primary
    var size: ButtonSize = .medium
    
    // MARK: - UI Enumlar
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .brandColor
            case .secondary:
                return .secondaryColor
            case .outline:
                return .clear
            case .destructive:
                return .error
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .outline:
                return .brandColor
            case .destructive, .primary, .secondary:
                return .white
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .outline:
                return .brandColor
            default:
                return nil
            }
        }
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium:
                return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            case .large:
                return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return AppConstants.FontSize.small
            case .medium:
                return AppConstants.FontSize.medium
            case .large:
                return AppConstants.FontSize.large
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            withAnimation {
                if !isDisabled {
                    action()
                }
            }
        }) {
            HStack(spacing: AppConstants.Layout.spacingMedium) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: size.fontSize))
                }
                
                Text(title)
                    .font(.system(size: size.fontSize, weight: .semibold))
            }
            .padding(size.padding)
            .frame(maxWidth: size == .large ? .infinity : nil)
            .background(isDisabled ? Color.systemGray3 : style.backgroundColor)
            .foregroundColor(isDisabled ? Color.white.opacity(0.7) : style.foregroundColor)
            .cornerRadius(AppConstants.Layout.cornerRadiusMedium)
            .overlay(
                Group {
                    if let borderColor = style.borderColor {
                        RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadiusMedium)
                            .stroke(borderColor, lineWidth: 1.5)
                    }
                }
            )
            .shadow(
                color: (style == .primary && !isDisabled) ? Color.brandColor.opacity(0.3) : Color.clear, 
                radius: AppConstants.Layout.shadowRadiusSmall, 
                x: 0, 
                y: 2
            )
        }
        .disabled(isDisabled)
        .scaleEffect(isDisabled ? 0.98 : 1)
    }
}

// MARK: - Önizleme
struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomButton(
                title: "Giriş Yap",
                icon: "arrow.forward",
                isDisabled: false,
                action: {}
            )
            
            CustomButton(
                title: "İptal",
                isDisabled: false,
                action: {},
                style: .secondary
            )
            
            CustomButton(
                title: "Çıkış",
                isDisabled: false,
                action: {},
                style: .destructive,
                size: .small
            )
            
            CustomButton(
                title: "Kayıt Ol",
                isDisabled: false,
                action: {},
                style: .outline,
                size: .large
            )
            
            CustomButton(
                title: "Devre Dışı",
                isDisabled: true,
                action: {}
            )
        }
        .padding()
    }
} 