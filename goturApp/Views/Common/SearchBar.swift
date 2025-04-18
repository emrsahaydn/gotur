import SwiftUI
import Foundation

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "1E88E5"))
                .padding(.leading, 8)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .padding(10)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Circle()
                        .fill(Color(hex: "1E88E5").opacity(0.2))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "1E88E5"))
                        )
                }
                .padding(.trailing, 8)
                .transition(.scale)
                .animation(.easeInOut, value: text)
            }
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: "1E88E5").opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color(hex: "4FC3F7").opacity(0.1)
            .edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 20) {
            SearchBar(text: .constant(""), placeholder: "Restoran ara")
            SearchBar(text: .constant("burger"), placeholder: "Yemek ara")
        }
        .padding()
    }
} 