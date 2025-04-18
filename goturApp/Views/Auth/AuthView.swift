import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isShowingLogin = true
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(hex: "1E88E5"))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "bag.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 30)
            
            Picker("", selection: $isShowingLogin) {
                Text("Giriş Yap").tag(true)
                Text("Kayıt Ol").tag(false)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if isShowingLogin {
                LoginView()
            } else {
                SignUpView()
            }
        }
        .padding()
    }
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Giriş Yap") {
                authViewModel.signIn(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty)
            
            Button("Şifremi Unuttum") {
                showForgotPassword = true
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Ad Soyad", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Şifre Tekrar", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Kayıt Ol") {
                authViewModel.signUp(email: email, password: password, name: name)
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty || name.isEmpty || password != confirmPassword)
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Şifre Sıfırlama")
                    .font(.title)
                    .padding()
                
                Text("E-posta adresinizi girin, size şifre sıfırlama bağlantısı göndereceğiz.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                
                Button("Şifre Sıfırlama Bağlantısı Gönder") {
                    authViewModel.resetPassword(email: email)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
} 