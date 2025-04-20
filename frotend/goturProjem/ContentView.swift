//
//  ContentView.swift
//  goturProjem
//
//  Created by Emir Şahin Aydın on 20.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var storeViewModel = StoreViewModel()
    @StateObject private var orderViewModel = OrderViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // Ana ekran
                MainTabView()
            } else {
                // Giriş ekranı
                LoginView()
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(storeViewModel)
        .environmentObject(orderViewModel)
    }
}

#Preview {
    ContentView()
}
