import SwiftUI
import Combine

struct SplashScreenView: View {
    @Binding var isActive: Bool
    
    // Timer state
    @State private var timeElapsed: Double = 0
    @State private var currentImage: String = "splash_gg"
    
    // Constants
    let totalDuration: Double = 5.0
    let switchTime: Double = 2.5
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("app_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Image Transition
                Image(currentImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .transition(.opacity)
                    .id(currentImage) // trigger transition
                
                Spacer()
                
                // Progress Bar
                VStack(spacing: 8) {
                    Text("\(min(Int((timeElapsed / totalDuration) * 100), 100))%")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .black)) // Reverted to smaller size (20) based on feedback
                        .italic()
                    
                    ProgressView(value: min(timeElapsed, totalDuration), total: totalDuration)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .scaleEffect(x: 1, y: 1, anchor: .center) 
                        .padding(.horizontal, 80)
                }
                .padding(.bottom, 120) // Increased from 50 to lift it up
            }
        }
        .onReceive(timer) { _ in
            if timeElapsed < totalDuration {
                timeElapsed += 0.1
                
                if timeElapsed >= switchTime && currentImage == "splash_gg" {
                    withAnimation {
                        currentImage = "splash_man"
                    }
                }
            } else {
                withAnimation {
                    // Slight delay to ensure 100% is seen
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(isActive: .constant(false))
}
