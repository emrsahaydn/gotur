import Foundation

struct User: Codable, Identifiable {
    var id: String
    var email: String
    var fullName: String
    var phoneNumber: String
    var address: String
    
    static var sample: User {
        User(id: UUID().uuidString, 
             email: "ornek@mail.com", 
             fullName: "Ahmet Yılmaz", 
             phoneNumber: "5551234567", 
             address: "İstanbul, Kadıköy")
    }
} 