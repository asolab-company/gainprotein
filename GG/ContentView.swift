import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showCalculator = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("app_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header Area
                    ZStack(alignment: .topTrailing) {
                        // Centered Image
                        HStack {
                            Spacer()
                            Image("welcome_hero")
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * 0.4)
                                .mask(
                                    LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .center, endPoint: .bottom)
                                )
                            Spacer()
                        }
                        
                        // Settings Icon
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.top, 50) // Push down below Dynamic Island
                    
                    // Main Content
                    VStack(alignment: .leading, spacing: 15) {
                        // Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Protein Calculator -")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .italic()
                                .foregroundColor(Color(red: 1.0, green: 70/255, blue: 0)) // #FF4600
                            
                            Text("Find Your Perfect Daily Protein Intake")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        
                        // New Calculation Button
                        NavigationLink(destination: CalculatorView(viewModel: viewModel), isActive: $showCalculator) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            showCalculator = true
                        }) {
                            Text("New Calculation")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 70/255, blue: 0))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        // List or Empty State
                        ZStack {
                            Color(white: 0.1).opacity(0.5) // Dark background for the bottom section
                                .ignoresSafeArea(edges: .bottom)
                            
                            if viewModel.savedProfiles.isEmpty {
                                // Empty State
                                VStack(spacing: 15) {
                                    Spacer()
                                    Image("empty_box") // Ensure this matches the asset name
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .opacity(0.8)
                                    
                                    Text("There are no calculations in your list yet.")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 50)
                            } else {
                                // Saved List
                                ScrollView {
                                    LazyVStack(spacing: 12) {
                                        ForEach(viewModel.savedProfiles) { profile in
                                            NavigationLink(destination: SavedProfileDetailView(profile: profile, viewModel: viewModel)) {
                                                GlassCard {
                                                    HStack {
                                                        VStack(alignment: .leading, spacing: 4) {
                                                            Text(profile.name)
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                            Text("\(String(format: "%.0f", profile.calculatedProtein)) g per day")
                                                                .font(.caption)
                                                                .foregroundColor(Color(red: 1.0, green: 70/255, blue: 0))
                                                        }
                                                        Spacer()
                                                        Image(systemName: "chevron.right")
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding()
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadProfiles() // Ensure profiles are loaded when view appears
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
