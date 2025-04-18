import SwiftUI

struct AddressViewModel: Identifiable {
    let id: String
    let title: String
    let fullAddress: String
    let latitude: Double
    let longitude: Double
}

struct ProfileView: View {
    @State private var name = "Ahmet Yılmaz"
    @State private var email = "ahmet.yilmaz@example.com"
    @State private var phone = "+90 555 123 4567"
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profil Başlığı
                        ZStack {
                            Circle()
                                .fill(Color(hex: "1E88E5"))
                                .frame(width: 120, height: 120)
                            
                            Text(String(name.split(separator: " ").map { $0.prefix(1) }.joined()))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Bilgiler
                        VStack(spacing: 15) {
                            ProfileInfoRow(icon: "envelope", title: "E-posta", value: email)
                            ProfileInfoRow(icon: "phone", title: "Telefon", value: phone)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                        .padding(.horizontal)
                        
                        // Aksiyonlar
                        VStack(spacing: 15) {
                            NavigationLink(destination: AddressListView()) {
                                ProfileActionRow(icon: "mappin.and.ellipse", title: "Adreslerim")
                            }
                            
                            NavigationLink(destination: OrdersScreen()) {
                                ProfileActionRow(icon: "bag", title: "Sipariş Geçmişim")
                            }
                            
                            Button(action: {
                                isEditingProfile = true
                            }) {
                                ProfileActionRow(icon: "person", title: "Profili Düzenle")
                            }
                            
                            ProfileActionRow(icon: "gear", title: "Ayarlar")
                            
                            Button(action: {
                                // Çıkış işlemi
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                    
                                    Text("Çıkış Yap")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Profilim")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(name: $name, email: $email, phone: $phone)
            }
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "1E88E5"))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ProfileActionRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "1E88E5"))
                .frame(width: 30)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String
    @Binding var email: String
    @Binding var phone: String
    
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""
    @State private var editedPhone: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("Ad Soyad", text: $editedName)
                    TextField("E-posta", text: $editedEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Telefon", text: $editedPhone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Profili Düzenle")
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    name = editedName
                    email = editedEmail
                    phone = editedPhone
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                editedName = name
                editedEmail = email
                editedPhone = phone
            }
        }
    }
}

struct AddressListView: View {
    @State private var addresses: [AddressViewModel] = [
        AddressViewModel(id: "1", title: "Ev", fullAddress: "Atatürk Mah. Cumhuriyet Cad. No:123, İstanbul", latitude: 41.0082, longitude: 28.9784),
        AddressViewModel(id: "2", title: "İş", fullAddress: "Levent Mah. Büyükdere Cad. No:456, İstanbul", latitude: 41.0811, longitude: 29.0178)
    ]
    
    var body: some View {
        List {
            ForEach(addresses) { address in
                VStack(alignment: .leading) {
                    Text(address.title)
                        .font(.headline)
                    Text(address.fullAddress)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
            .onDelete(perform: deleteAddress)
            
            NavigationLink(destination: AddAddressView()) {
                Label("Yeni Adres Ekle", systemImage: "plus")
                    .foregroundColor(.orange)
            }
        }
        .navigationTitle("Adreslerim")
    }
    
    private func deleteAddress(at offsets: IndexSet) {
        addresses.remove(atOffsets: offsets)
    }
}

struct AddAddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var address = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Başlık (Ev, İş vb.)", text: $title)
                TextField("Adres", text: $address)
                    .frame(height: 100, alignment: .top)
                    .multilineTextAlignment(.leading)
            }
        }
        .navigationTitle("Yeni Adres")
        .navigationBarItems(
            trailing: Button("Kaydet") {
                // TODO: Adres kaydetme
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(title.isEmpty || address.isEmpty)
        )
    }
}

#Preview {
    ProfileView()
} 