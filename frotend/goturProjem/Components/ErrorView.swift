import SwiftUI

struct ErrorView: View {
    var errorMessage: String?
    
    var body: some View {
        if let error = errorMessage, !error.isEmpty {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
            .transition(.scale.combined(with: .opacity))
        } else {
            EmptyView()
        }
    }
}

struct SuccessView: View {
    var message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.green)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.green)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.green.opacity(0.2), lineWidth: 1)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorView(errorMessage: "Geçersiz e-posta adresi")
        SuccessView(message: "İşlem başarıyla tamamlandı")
    }
    .padding()
} 