import SwiftUI

struct RootView: View {
    enum AppScreen {
        case splash
        case welcome
        case main
    }
    
    @State private var currentScreen: AppScreen = .splash
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashScreenView(isActive: Binding(
                    get: { false },
                    set: { _ in
                        if hasSeenWelcome {
                            currentScreen = .main
                        } else {
                            currentScreen = .welcome
                        }
                    }
                ))
            case .welcome:
                WelcomeView {
                    withAnimation {
                        hasSeenWelcome = true
                        currentScreen = .main
                    }
                }
            case .main:
                ContentView()
            }
        }
        .preferredColorScheme(.dark)
    }
}
