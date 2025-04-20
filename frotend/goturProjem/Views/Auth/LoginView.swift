import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showForgotPassword = false
    @State private var showRegister = false
    @State private var showVerification = false
    @State private var animateLogo = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Logo
                    VStack(spacing: 10) {
                        Image(systemName: "bag.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color.brandColor)
                            .padding(.bottom, 10)
                            .scaleEffect(animateLogo ? 1.1 : 1.0)
                            .shadow(color: Color.brandColor.opacity(0.3), radius: animateLogo ? 10 : 5, x: 0, y: 0)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateLogo)
                        
                        Text("Götür")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color.brandColor)
                            .padding(.bottom, 20)
                    }
                    .padding(.top, 40)
                    .onAppear {
                        animateLogo = true
                    }
                    
                    // Hata mesajı
                    ErrorView(errorMessage: authViewModel.errorMessage)
                    
                    // Giriş formu
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "E-posta",
                            text: $authViewModel.loginEmail,
                            keyboardType: .emailAddress
                        )
                        
                        CustomTextField(
                            title: "Şifre",
                            text: $authViewModel.loginPassword,
                            isSecure: true
                        )
                        
                        // Şifremi unuttum butonu
                        HStack {
                            Spacer()
                            Button("Şifremi Unuttum") {
                                showForgotPassword = true
                            }
                            .foregroundColor(Color.brandColor)
                            .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Giriş butonu
                    CustomButton(
                        title: "Giriş Yap",
                        icon: "arrow.right.circle",
                        isDisabled: authViewModel.loginEmail.isEmpty || authViewModel.loginPassword.isEmpty,
                        action: {
                            withAnimation {
                                authViewModel.login()
                            }
                            
                            // Test amaçlı 2FA ekranına yönlendirme
                            if authViewModel.loginEmail == "2fa@mail.com" {
                                showVerification = true
                            }
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Kayıt ol
                    HStack {
                        Text("Hesabınız yok mu?")
                            .foregroundColor(.gray)
                        
                        Button("Kayıt Ol") {
                            showRegister = true
                        }
                        .foregroundColor(Color.brandColor)
                        .fontWeight(.bold)
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    // Test hesabı bilgileri
                    VStack(spacing: 4) {
                        Text("Test hesabı:")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("E-posta: test@mail.com")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("Şifre: 123456")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                }
                .padding()
                .navigationDestination(isPresented: $showRegister) {
                    RegisterView()
                }
                .navigationDestination(isPresented: $showForgotPassword) {
                    ForgotPasswordView()
                }
                .navigationDestination(isPresented: $showVerification) {
                    VerificationView()
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
} 