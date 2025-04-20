import SwiftUI

struct VerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Başlık
            Text("Doğrulama Kodu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("E-posta adresinize gönderilen 6 haneli doğrulama kodunu girin")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Hata mesajı
            ErrorView(errorMessage: authViewModel.errorMessage)
            
            // Form
            VStack(spacing: 16) {
                CustomTextField(
                    title: "Doğrulama Kodu",
                    text: $authViewModel.verificationCode,
                    keyboardType: .numberPad
                )
            }
            .padding(.top, 20)
            
            // Doğrulama butonu
            CustomButton(
                title: "Doğrula",
                icon: "checkmark.circle",
                isDisabled: authViewModel.verificationCode.isEmpty,
                action: authViewModel.verifyCode
            )
            .padding(.top, 20)
            
            // Yeniden gönder
            Button("Kodu Yeniden Gönder") {
                // Kod yeniden gönderme işlemi
            }
            .foregroundColor(Color("PrimaryColor"))
            .padding(.top, 12)
            
            Spacer()
            
            // Test bilgisi
            Text("Test için kod: 123456")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .padding()
        .navigationTitle("Kod Doğrulama")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        VerificationView()
            .environmentObject(AuthViewModel())
    }
} 