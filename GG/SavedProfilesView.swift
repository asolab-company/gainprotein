import SwiftUI

struct SavedProfilesView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        ZStack {
            Image("app_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                Text("Saved Profiles")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if viewModel.savedProfiles.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "person.crop.circle.badge.questionmark")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("No saved profiles yet.")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.top, 50)
                        } else {
                            ForEach(viewModel.savedProfiles) { profile in
                                GlassCard {
                                    HStack(spacing: 15) {
                                        // Icon
                                        ZStack {
                                            Circle()
                                                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 50, height: 50)
                                            Text(String(profile.name.prefix(1)).uppercased())
                                                .font(.headline)
                                                .bold()
                                                .foregroundColor(.white)
                                        }
                                        
                                        // Content
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(profile.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                            Text(profile.date, style: .date)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        // Result
                                        VStack(alignment: .trailing) {
                                            Text("\(String(format: "%.0f", profile.calculatedProtein))g")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.orange)
                                            Text("daily")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        if let index = viewModel.savedProfiles.firstIndex(where: { $0.id == profile.id }) {
                                            viewModel.deleteProfile(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    SavedProfilesView()
}
