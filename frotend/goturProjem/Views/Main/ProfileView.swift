import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfile = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                if let user = authViewModel.currentUser {
                    // Kullanıcı bilgileri
                    Section {
                        HStack {
                            // Profil resmi placeholder
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color("PrimaryColor"))
                            
                            // Kullanıcı bilgileri
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Hesap
                    Section {
                        NavigationLink(destination: {
                            EditProfileView(user: user)
                        }) {
                            Label("Hesap Bilgilerimi Düzenle", systemImage: "person")
                        }
                        
                        NavigationLink(destination: {
                            OrdersView()
                        }) {
                            Label("Siparişlerim", systemImage: "doc.text")
                        }
                        
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Label("Çıkış Yap", systemImage: "arrow.right.square")
                                .foregroundColor(.red)
                        }
                    } header: {
                        Text("Hesap")
                    }
                    
                    // Uygulama hakkında
                    Section {
                        NavigationLink(destination: {
                            Text("Yardım ve Destek")
                        }) {
                            Label("Yardım ve Destek", systemImage: "questionmark.circle")
                        }
                        
                        NavigationLink(destination: {
                            Text("Hakkında")
                        }) {
                            Label("Hakkında", systemImage: "info.circle")
                        }
                    } header: {
                        Text("Uygulama")
                    }
                }
            }
            .navigationTitle("Profil")
            .alert("Çıkış Yap", isPresented: $showLogoutAlert) {
                Button("İptal", role: .cancel) {}
                Button("Çıkış Yap", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Çıkış yapmak istediğinize emin misiniz?")
            }
        }
    }
}

struct EditProfileView: View {
    let user: User
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String
    @State private var phoneNumber: String
    @State private var address: String
    @State private var showSuccess = false
    
    init(user: User) {
        self.user = user
        self._fullName = State(initialValue: user.fullName)
        self._phoneNumber = State(initialValue: user.phoneNumber)
        self._address = State(initialValue: user.address)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hata mesajı
                ErrorView(errorMessage: authViewModel.errorMessage)
                
                // Başarı mesajı
                if showSuccess {
                    SuccessView(message: "Profil bilgileriniz güncellendi")
                }
                
                // Form
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Ad Soyad",
                        text: $fullName
                    )
                    
                    CustomTextField(
                        title: "Telefon Numarası",
                        text: $phoneNumber,
                        keyboardType: .phonePad
                    )
                    
                    CustomTextField(
                        title: "Adres",
                        text: $address
                    )
                }
                .padding(.top, 8)
                
                // Güncelle butonu
                CustomButton(
                    title: "Güncelle",
                    icon: "checkmark.circle",
                    isDisabled: fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty ||
                    (fullName == user.fullName && phoneNumber == user.phoneNumber && address == user.address),
                    action: updateProfile
                )
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Hesap Bilgilerim")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateProfile() {
        authViewModel.updateProfile(
            fullName: fullName,
            phoneNumber: phoneNumber,
            address: address
        )
        
        // Başarı mesajını göster
        showSuccess = true
        
        // 2 saniye sonra önceki ekrana dön
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
} 