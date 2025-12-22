import SwiftUI

struct CalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @FocusState private var isInputFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    // Derived state to check if result is shown
    var isResultShown: Bool {
        return viewModel.resultProtein != nil
    }
    
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
                    }
                    
                    Text("Calculation")
                        .font(.headline)
                        .italic()
                        .foregroundColor(.white)
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // How It Works Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How It Works")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Just enter a few basic details.\nOur algorithm will instantly calculate your personalized daily protein target using scientifically backed formulas.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Inputs
                        VStack(spacing: 16) {
                            // Name
                            DarkTextField(
                                placeholder: "Enter the name",
                                text: $viewModel.profileName
                            )
                            .focused($isInputFocused)
                            
                            // Unit System
                            DarkPickerMenu(
                                title: "Preferred Units",
                                selection: $viewModel.unitSystem,
                                options: UnitSystem.allCases
                            )
                            
                            // Weight
                            DarkTextField(
                                placeholder: viewModel.unitSystem == nil ? "Weight" : (viewModel.unitSystem == .imperial ? "Weight (lbs)" : "Weight (kg)"),
                                text: $viewModel.weightString
                            )
                            .keyboardType(.decimalPad)
                            .focused($isInputFocused)
                            .onChange(of: viewModel.weightString) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    viewModel.weightString = filtered
                                }
                            }
                            
                            // Age
                            DarkTextField(
                                placeholder: "Age",
                                text: $viewModel.ageString
                            )
                            .keyboardType(.numberPad)
                            .focused($isInputFocused)
                            .onChange(of: viewModel.ageString) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    viewModel.ageString = filtered
                                }
                            }
                            
                            // Sex
                            DarkPickerMenu(
                                title: "Sex",
                                selection: $viewModel.sex,
                                options: Sex.allCases
                            )
                            
                            // Activity
                            DarkPickerMenu(
                                title: "Activity Level",
                                selection: $viewModel.activity,
                                options: ActivityLevel.allCases
                            )
                            
                            // Goal
                            DarkPickerMenu(
                                title: "Goal",
                                selection: $viewModel.goal,
                                options: Goal.allCases
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
                
                // Pinned Results/Button Section
                VStack(spacing: 0) {
                    if let protein = viewModel.resultProtein {
                        VStack(spacing: 16) {
                            // Result Display
                            HStack {
                                Text("\(String(format: "%.0f", protein))g per day")
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
                            
                            // Buttons
                            PrimaryButton(title: "Save") {
                                viewModel.saveProfile()
                                dismiss()
                            }
                            
                            PrimaryButton(title: "New Calculation") {
                                viewModel.resetCalculation()
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.8)) // Optional: Add background to footer
                    } else {
                        // Calculate Button
                        if viewModel.isFormValid {
                            PrimaryButton(title: "Calculate") {
                                isInputFocused = false
                                viewModel.calculate()
                            }
                            .padding()
                            .background(Color.black.opacity(0.8)) // Optional: Add background to footer
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
            }
        }
    }
}

#Preview {
    CalculatorView(viewModel: CalculatorViewModel())
}
