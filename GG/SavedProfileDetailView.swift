import SwiftUI

struct SavedProfileDetailView: View {
    let profile: SavedProfile
    @ObservedObject var viewModel: CalculatorViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var navigateToNewCalculation = false
    @State private var showSources = false // Navigation state
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()
                        Button(action: {
                            if let index = viewModel.savedProfiles.firstIndex(where: { $0.id == profile.id }) {
                                viewModel.deleteProfile(at: IndexSet(integer: index))
                                dismiss()
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(Color.ggOrange)
                                .font(.headline)
                        }
                    }
                    
                    Text(profile.name)
                        .font(.headline)
                        .italic()
                        .foregroundColor(.white)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Read-only fields mimicking the input style
                        // Unit System (Dropdown look)
                        ReadOnlyDropdown(text: profile.input.unitSystem.description)
                        
                        // Weight (Text field look - no arrow)
                        ReadOnlyField(text: "\(Int(profile.input.weight))")
                        
                        // Age (Text field look - no arrow)
                        ReadOnlyField(text: "\(profile.input.age)")
                        
                        
                        // Activity (Dropdown look)
                        ReadOnlyDropdown(text: profile.input.activity.description)
                        
                        // Goal (Dropdown look)
                        ReadOnlyDropdown(text: profile.input.goal.description)
                        
                        // Result Box
                        HStack {
                            Text("\(String(format: "%.0f", profile.calculatedProtein))g per day")
                                .font(.headline)
                                .foregroundColor(Color.ggOrange)
                            Spacer()
                        }
                        .padding()
                        .background(Color.darkField)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.ggOrange.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.top, 10)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
                
                // Pinned Button
                VStack {
                    ZStack {
                        PrimaryButton(title: "New Calculation") {
                            viewModel.resetCalculation()
                            navigateToNewCalculation = true
                        }
                        
                        NavigationLink(destination: CalculatorView(viewModel: viewModel), isActive: $navigateToNewCalculation) {
                            EmptyView()
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                }
                
                // Disclaimer Footer (Pinned at very bottom)
                VStack(spacing: 8) {
                    Text("This calculation is for informational purposes only and does not replace professional medical advice.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showSources = true
                    }) {
                        Text("Sources")
                            .font(.caption)
                            .foregroundColor(.ggOrange)
                    }
                    
                    NavigationLink(destination: SourcesView(), isActive: $showSources) {
                        EmptyView()
                    }
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ReadOnlyField: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.white)
            Spacer()
            // No chevron or inputs, just the value container
            // Screenshot shows arrows for dropdowns?
            // "Metric (kg, g)" has an arrow. "55" does not. "Female" has an arrow.
            // Screenshot 2 shows:
            // Metric -> Arrow
            // 55 -> No Arrow
            // 33 -> No Arrow
            // Female -> Arrow
            // Light Activity -> Arrow
            // Weight Loss -> Arrow
            // So it mimics the DarkPickerMenu look for enums, and TextField look for numbers.
        }
        .padding()
        .background(Color.darkField)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// Helper for "Fake" Dropdown look
struct ReadOnlyDropdown: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.white)
                .font(.caption)
        }
        .padding()
        .background(Color.darkField)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}
