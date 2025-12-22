import SwiftUI

struct WelcomeView: View {
    var onStart: () -> Void
    @EnvironmentObject var legalStore: LegalStore
    
    @State private var showTerms = false
    @State private var showPrivacy = false
    
    var body: some View {
            Image("app_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: -20) { // Negative spacing to pull text slightly into the fade if needed
                Spacer()
                
                Image("welcome_hero")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .center, endPoint: .bottom)
                    )
                
                VStack(spacing: 20) {
                    // Text Content
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("G")
                                .foregroundColor(Color(red: 1, green: 70/255, blue: 0))
                            Text("ROW STRONG,")
                                .foregroundColor(.white)
                        }
                        .font(.system(size: 40, weight: .black))
                        .italic()
                        
                        HStack(spacing: 0) {
                            Text("G")
                                .foregroundColor(Color(red: 1, green: 70/255, blue: 0))
                            Text("ROW SMART!")
                                .foregroundColor(.white)
                        }
                        .font(.system(size: 40, weight: .black))
                        .italic()
                    }
                    .multilineTextAlignment(.center)
                    
                    Text("Welcome to your personal Protein Calculator — a simple and accurate tool that helps you understand exactly how much protein your body needs every day. Whether your goal is weight loss, muscle gain, or maintaining a healthy lifestyle, we’ve got you covered.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .layoutPriority(1) // Ensure text doesn't get squished
                    
                    // Button
                    Button(action: onStart) {
                        Text("Start Now")
                            .font(.title3) // Increased from headline
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1.0, green: 70/255, blue: 0))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    // Footer
                    VStack(spacing: 2) {
                        Text("By Proceeding You Accept")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        HStack(spacing: 0) {
                            Text("Our ")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("Terms Of Use")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .onTapGesture {
                                    showTerms = true
                                }
                            Text(" And ")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("Privacy Policy")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .onTapGesture {
                                    showPrivacy = true
                                }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .sheet(isPresented: $showTerms) {
                LegalView(title: "Terms and Conditions", content: legalStore.termsAndConditions)
            }
            .sheet(isPresented: $showPrivacy) {
                LegalView(title: "Privacy Policy", content: legalStore.privacyPolicy)
            }
    }
}

#Preview {
    WelcomeView(onStart: {})
}
