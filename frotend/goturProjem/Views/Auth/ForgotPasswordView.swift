import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Başlık
            Text("Şifremi Unuttum")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Şifrenizi sıfırlamak için e-posta adresinizi girin")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Hata mesajı
            ErrorView(errorMessage: authViewModel.errorMessage)
            
            // Başarılı mesajı
            if showSuccess {
                SuccessView(message: "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi")
            }
            
            // Form
            VStack(spacing: 16) {
                CustomTextField(
                    title: "E-posta",
                    text: $authViewModel.resetEmail,
                    keyboardType: .emailAddress
                )
            }
            .padding(.top, 20)
            
            // Şifre sıfırlama butonu
            CustomButton(
                title: "Şifre Sıfırlama Bağlantısı Gönder",
                icon: "envelope",
                isDisabled: authViewModel.resetEmail.isEmpty,
                action: {
                    authViewModel.resetPassword()
                    showSuccess = true
                }
            )
            .padding(.top, 20)
            
            // Geri dön
            Button("Giriş Ekranına Dön") {
                dismiss()
            }
            .foregroundColor(Color("PrimaryColor"))
            .padding(.top, 12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Şifre Sıfırlama")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
            .environmentObject(AuthViewModel())
    }
} 