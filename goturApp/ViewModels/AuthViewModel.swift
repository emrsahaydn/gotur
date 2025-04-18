import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func signIn(email: String, password: String) {
        isLoading = true
        // TODO: API entegrasyonu eklenecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        isLoading = true
        // TODO: API entegrasyonu eklenecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func resetPassword(email: String) {
        isLoading = true
        // TODO: API entegrasyonu eklenecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.errorMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
    
    func updateProfile(name: String, email: String) {
        isLoading = true
        // TODO: API entegrasyonu eklenecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
} 