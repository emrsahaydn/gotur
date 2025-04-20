//
//  goturProjemApp.swift
//  goturProjem
//
//  Created by Emir Şahin Aydın on 20.04.2025.
//

import SwiftUI

@main
struct goturProjemApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear {
                    // UI ayarlarını yapılandır
                    setupAppearance()
                }
        }
    }
    
    private func setupAppearance() {
        // NavigationBar görünümünü özelleştir
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        
        // Standart görünüm ve kaydırırken görünüm ayarları
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // TabBar görünümünü özelleştir
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
