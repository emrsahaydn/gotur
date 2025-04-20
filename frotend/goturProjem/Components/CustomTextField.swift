import SwiftUI

struct CustomTextField: View {
    var title: String
    var text: Binding<String>
    var isSecure: Bool
    var keyboardType: UIKeyboardType
    
    init(title: String, text: Binding<String>, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.gray)
            
            if isSecure {
                SecureField("", text: text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            } else {
                TextField("", text: text)
                    .padding()
                    .keyboardType(keyboardType)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}

struct CustomTextEditor: View {
    var title: String
    var text: Binding<String>
    var maxHeight: CGFloat
    
    init(title: String, text: Binding<String>, maxHeight: CGFloat = 150) {
        self.title = title
        self.text = text
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            TextEditor(text: text)
                .frame(minHeight: 100, maxHeight: maxHeight)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(title: "E-posta", text: .constant("ornek@mail.com"))
        CustomTextField(title: "Şifre", text: .constant("123456"), isSecure: true)
        CustomTextField(title: "Telefon Numarası", text: .constant("5551234567"), keyboardType: .phonePad)
        CustomTextEditor(title: "Teslimat Notu", text: .constant("Lütfen kapıyı çalmayın"))
    }
    .padding()
} 