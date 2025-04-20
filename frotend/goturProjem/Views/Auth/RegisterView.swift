import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Başlık
                Text("Yeni Hesap Oluştur")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Hata mesajı
                ErrorView(errorMessage: authViewModel.errorMessage)
                
                // Form
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Ad Soyad",
                        text: $authViewModel.registerFullName
                    )
                    
                    CustomTextField(
                        title: "E-posta",
                        text: $authViewModel.registerEmail,
                        keyboardType: .emailAddress
                    )
                    
                    CustomTextField(
                        title: "Telefon Numarası",
                        text: $authViewModel.registerPhoneNumber,
                        keyboardType: .phonePad
                    )
                    
                    CustomTextField(
                        title: "Şifre",
                        text: $authViewModel.registerPassword,
                        isSecure: true
                    )
                    
                    CustomTextField(
                        title: "Şifre Tekrar",
                        text: $authViewModel.registerConfirmPassword,
                        isSecure: true
                    )
                }
                
                // Kayıt ol butonu
                CustomButton(
                    title: "Kayıt Ol",
                    icon: "person.fill.badge.plus",
                    isDisabled: authViewModel.registerEmail.isEmpty || 
                               authViewModel.registerPassword.isEmpty ||
                               authViewModel.registerConfirmPassword.isEmpty ||
                               authViewModel.registerFullName.isEmpty ||
                               authViewModel.registerPhoneNumber.isEmpty,
                    action: {
                        authViewModel.register()
                    }
                )
                .padding(.top, 20)
                
                // Giriş yap
                HStack {
                    Text("Zaten hesabınız var mı?")
                        .foregroundColor(.gray)
                    
                    Button("Giriş Yap") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryColor"))
                    .fontWeight(.bold)
                }
                .padding(.top, 12)
            }
            .padding()
        }
        .navigationTitle("Kayıt Ol")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
} 