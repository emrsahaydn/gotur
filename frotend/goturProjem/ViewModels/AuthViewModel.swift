import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Kayıt işlemi için form alanları
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var registerConfirmPassword = ""
    @Published var registerFullName = ""
    @Published var registerPhoneNumber = ""
    @Published var registerAddress = ""
    
    // Giriş işlemi için form alanları
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    // Şifre sıfırlama için form alanı
    @Published var resetEmail = ""
    
    // 2FA için doğrulama kodu
    @Published var verificationCode = ""
    
    // Mock kimlik doğrulama fonksiyonları - Gerçek uygulamada bir sunucu API'sına bağlanacak
    func register() {
        guard validateRegisterForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Burada sunucu API'sına kayıt isteği gönderilecek
        // Simülasyon için bir gecikme ekleyelim
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Başarılı kayıt simülasyonu
            let newUser = User(
                id: UUID().uuidString,
                email: self.registerEmail,
                fullName: self.registerFullName,
                phoneNumber: self.registerPhoneNumber,
                address: self.registerAddress
            )
            
            self.currentUser = newUser
            self.isAuthenticated = true
            self.isLoading = false
            self.clearRegisterForm()
        }
    }
    
    func login() {
        guard validateLoginForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Burada sunucu API'sına giriş isteği gönderilecek
        // Simülasyon için bir gecikme ekleyelim
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Test amaçlı basit doğrulama
            if self.loginEmail == "test@mail.com" && self.loginPassword == "123456" {
                self.currentUser = User.sample
                self.isAuthenticated = true
                self.clearLoginForm()
            } else {
                self.errorMessage = "Geçersiz e-posta veya şifre"
            }
            
            self.isLoading = false
        }
    }
    
    func resetPassword() {
        guard !resetEmail.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Burada şifre sıfırlama e-postası gönderilecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Başarılı e-posta gönderimi simülasyonu
            self.isLoading = false
            self.resetEmail = ""
            // Gerçek uygulamada buradan bir doğrulama ekranına yönlendirilecek
        }
    }
    
    func verifyCode() {
        guard !verificationCode.isEmpty else {
            errorMessage = "Lütfen doğrulama kodunu girin"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Burada 2FA kodu doğrulanacak
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Test amaçlı doğrulama (gerçek kodlar sunucudan gelecek)
            if self.verificationCode == "123456" {
                self.isAuthenticated = true
                self.verificationCode = ""
            } else {
                self.errorMessage = "Geçersiz doğrulama kodu"
            }
            
            self.isLoading = false
        }
    }
    
    func logout() {
        isLoading = true
        
        // Burada çıkış işlemi yapılacak
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.currentUser = nil
            self.isAuthenticated = false
            self.isLoading = false
        }
    }
    
    func updateProfile(fullName: String, phoneNumber: String, address: String) {
        guard var user = currentUser else { return }
        
        isLoading = true
        
        // Kullanıcı profilini güncelle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            user.fullName = fullName
            user.phoneNumber = phoneNumber
            user.address = address
            
            self.currentUser = user
            self.isLoading = false
        }
    }
    
    // Validasyon fonksiyonları
    private func validateRegisterForm() -> Bool {
        guard !registerEmail.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin"
            return false
        }
        
        guard !registerPassword.isEmpty else {
            errorMessage = "Lütfen şifrenizi girin"
            return false
        }
        
        guard registerPassword == registerConfirmPassword else {
            errorMessage = "Şifreler eşleşmiyor"
            return false
        }
        
        guard !registerFullName.isEmpty else {
            errorMessage = "Lütfen adınızı ve soyadınızı girin"
            return false
        }
        
        guard !registerPhoneNumber.isEmpty else {
            errorMessage = "Lütfen telefon numaranızı girin"
            return false
        }
        
        return true
    }
    
    private func validateLoginForm() -> Bool {
        guard !loginEmail.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin"
            return false
        }
        
        guard !loginPassword.isEmpty else {
            errorMessage = "Lütfen şifrenizi girin"
            return false
        }
        
        return true
    }
    
    private func clearRegisterForm() {
        registerEmail = ""
        registerPassword = ""
        registerConfirmPassword = ""
        registerFullName = ""
        registerPhoneNumber = ""
        registerAddress = ""
    }
    
    private func clearLoginForm() {
        loginEmail = ""
        loginPassword = ""
    }
} 