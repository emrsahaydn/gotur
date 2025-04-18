import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowingSplash = false
                            }
                        }
                    }
            } else {
                NavigationStack {
                    if authViewModel.isAuthenticated {
                        MainTabView()
                            .environmentObject(authViewModel)
                    } else {
                        AuthView()
                            .environmentObject(authViewModel)
                    }
                }
            }
        }
    }
}

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulsate = false
    
    var body: some View {
        ZStack {
            // Gradient arka plan
            LinearGradient(
                gradient: Gradient(colors: [.vibrantOrange, .vibrantRed]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Yemek desenleri arka planda (küçük ikonlar)
            ZStack {
                ForEach(0..<20) { i in
                    Image(systemName: ["fork.knife", "cup.and.saucer", "flame", "leaf.fill", "drop"][i % 5])
                        .font(.system(size: CGFloat.random(in: 15...30)))
                        .foregroundColor(.white.opacity(0.2))
                        .position(
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 50...750)
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                }
            }
            
            VStack(spacing: 25) {
                // Logo
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                    
                    // Pulsating effect
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 5)
                        .frame(width: pulsate ? 180 : 160, height: pulsate ? 180 : 160)
                        .scaleEffect(isAnimating ? 1 : 0.5)
                    
                    Image(systemName: "bag.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.vibrantOrange)
                        .scaleEffect(isAnimating ? 1 : 0.1)
                        .rotationEffect(.degrees(isAnimating ? 0 : -90))
                }
                
                // App name
                VStack(spacing: 15) {
                    Text("GÖTÜR")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Hızlı Teslimat")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .scaleEffect(isAnimating ? 1 : 0.5)
                .opacity(isAnimating ? 1 : 0)
            }
            .offset(y: isAnimating ? 0 : 50)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5)) {
                isAnimating = true
            }
            
            // Pulsating animation
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulsate = true
            }
        }
    }
}

#Preview {
    ContentView()
} 